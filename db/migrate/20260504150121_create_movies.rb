class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.float :rating
      t.text :overview
      t.string :poster_url

      t.timestamps
    end
  end
end
