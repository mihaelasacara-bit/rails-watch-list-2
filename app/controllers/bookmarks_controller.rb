class BookmarksController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new

    if @bookmark.save
      redirect_to list_path(@list), notice: "Bookmark added!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
