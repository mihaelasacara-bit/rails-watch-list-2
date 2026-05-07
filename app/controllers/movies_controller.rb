class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    @list = List.find(params[:list_id])
  end
end
