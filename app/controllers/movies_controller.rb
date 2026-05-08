class MoviesController < ApplicationController
  def index
    @list = List.find(params[:list_id])

    if params[:query].present?
      @movies = TmdbService.search(params[:query])
    else
      begin
        results = Rails.cache.fetch("tmdb_top_rated", expires_in: 1.hour) do
          TmdbService.fetch_top_rated
        end

        Movie.upsert_all(
          results.map do |m|
            {
              title:      m["title"],
              overview:   m["overview"],
              rating:     m["vote_average"],
              tmdb_id:    m["id"],
              poster_url: "https://image.tmdb.org/t/p/w500#{m["poster_path"]}",
              updated_at: Time.current,
              created_at: Time.current
            }
          end,
          unique_by: :tmdb_id   # swap for :tmdb_id once you add that column (see Step 4)
        )
      rescue OpenURI::HTTPError, JSON::ParserError, SocketError => e
        Rails.logger.error("TMDB fetch failed: #{e.message}")
        flash.now[:alert] = "Could not refresh movies from TMDB."
      end

      @movies = Movie.all
      @list = List.find(params[:list_id])
    end
  end
end
