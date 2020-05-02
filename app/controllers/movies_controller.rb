class MoviesController < ApplicationController
  def index
    movies = Movie.all
    movies = movies.map do |movie|
      movie.attributes.merge(
        'casting' => movie.actors_in_movie.map {|p| [p.id, p.name]},
        'directors' => movie.directors_in_movie.map {|p| [p.id, p.name]},
        'producers' => movie.producers_in_movie.map {|p| [p.id, p.name]},
        'release_year' => romanize(movie.release_year)
      )
    end
    render json: movies
  end
end