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

  def create
    movie = Movie.create(title: movie_params[:title], release_year: movie_params[:release_year])
    [:actors_in_movie, :directors_in_movie, :producers_in_movie].each do |key|
      movie_params[key].each do |person_id|
        movie.send(key) << Person.find_by(id: person_id)
      end
    end
    render json: {message: "Movie #{movie.title} created"}
  end

  def update
    movie = Movie.find_by(id: params[:id])
    movie.update_attributes!(movie_attributes)
    [:actors_in_movie, :directors_in_movie, :producers_in_movie].each do |key|
      movie.send(key).delete_all #remove associated people to movie
      movie_params[key].each do |person_id|
        movie.send(key) << Person.find_by(id: person_id)
      end
    end
    render json: {message: "Movie #{movie.title} updated"}
  end

  def destroy
    movie = Movie.find_by(id: params[:id])
    movie.destroy
    render json: {message: "Movie #{movie.title} deleted"}
  end

  private

  def movie_attributes
    movie_params.permit(:title, :release_year)
  end

  def movie_params
    params.require(:movie)
  end
end