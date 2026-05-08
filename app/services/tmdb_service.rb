class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"
  API_KEY  = ENV["TMDB_API_KEY"]

  def self.fetch_top_rated(pages: 5)
    (1..pages).flat_map do |page|
      url = "#{BASE_URL}/movie/top_rated?language=en-US&api_key=#{API_KEY}&page=#{page}"
      data = JSON.parse(URI.open(url).read)
      data["results"]
    end
  end

  def self.search(query)
    url = "#{BASE_URL}/search/movie?api_key=#{API_KEY}&query=#{URI.encode_www_form_component(query)}"
    data = JSON.parse(URI.open(url).read)
    data["results"].filter_map do |m|
      next if m["id"].nil? || m["title"].nil?
      movie = Movie.find_or_create_by(tmdb_id: m["id"]) do |record|
        record.title      = m["title"]
        record.overview   = m["overview"]
        record.rating     = m["vote_average"]
        record.poster_url = "https://image.tmdb.org/t/p/w500#{m["poster_path"]}"
        record.tmdb_id    =  m["id"]
      end
      Rails.logger.debug "Movie: #{movie.title} - persisted: #{movie.persisted?} - errors: #{movie.errors.full_messages}"
      next if movie.id.nil?
      movie
    end.first(6)
  rescue OpenURI::HTTPError, JSON::ParserError, SocketError => e
  Rails.logger.error("TMDB search failed: #{e.message}")
  []
  end
end
