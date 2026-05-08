class AddUniqueIndexToMoviesTmdbId < ActiveRecord::Migration[8.1]
  def change
    add_index :movies, :tmdb_id, unique: true
  end
end
