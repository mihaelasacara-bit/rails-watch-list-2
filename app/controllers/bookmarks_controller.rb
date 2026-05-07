class BookmarksController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    @movie = Movie.find(params[:movie_id])
    @bookmark = Bookmark.new(list: @list, movie: @movie)

    if @bookmark.save
      redirect_to list_movies_path, notice: "Bookmark added!"
    else
      redirect_to list_movies_path, alert: @bookmark.errors.full_messages.join(", ")
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @list = List.find(params[:list_id])
    @bookmark.destroy
    redirect_to list_path(@list), notice: "Bookmark removed!"
  end
end
