class MoviesController < ApplicationController
  before_action :get_movie, only: [:update, :destroy]

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
    movie = Movie.new(title: movie_params[:title], release_year: movie_params[:release_year])
    [:actors_in_movie, :directors_in_movie, :producers_in_movie].each do |key|
      movie_params[key].each do |person_id|
        person = Person.find_by(id: person_id)
        movie.send(key) << person if person
      end
    end
    if movie.save!
      render json: {message: "Movie #{movie.title} created"}
    else
      render json: {message: "Movie #{movie.title} not created"}
    end
  end

  def update
    if @movie&.update_attributes!(movie_attributes)
      [:actors_in_movie, :directors_in_movie, :producers_in_movie].each do |key|
        @movie.send(key).delete_all #remove associated people to movie
        movie_params[key].each do |person_id|
          person = Person.find_by(id: person_id)
          @movie.send(key) << person if person.present?
        end
      end
      render json: {message: "Movie #{@movie.title} updated"}
    else
      render json: {message: "Movie with id #{params[:id]} not updated"}
    end
  end

  def destroy
    if @movie
      @movie.destroy 
      render json: {message: "Movie #{@movie.title} deleted"}
    else
      render json: {message: "Movie with id #{params[:id]} does not exist"}
    end
  end

  private

  def get_movie
    @movie = Movie.find_by(id: params[:id])
  end

  def movie_attributes
    movie_params.permit(:title, :release_year)
  end

  def movie_params
    params.require(:movie)
  end
end