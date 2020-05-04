class PeopleController < ApplicationController

  before_action :get_person, only: [:update, :destroy]

  def index
    people = Person.all
    people = people.map do |person|
      person.attributes.merge(
        'movies_as_actor' => person.movies_as_actor.map {|p| [p.id, p.title]},
        'movies_as_director' => person.movies_as_director.map {|p| [p.id, p.title]},
        'movies_as_producer' => person.movies_as_producer.map {|p| [p.id, p.title]} 
      )
    end
    render json: people
  end


  def create
    person = Person.new(first_name: person_params[:first_name], last_name: person_params[:last_name], aliases: person_params[:aliases])
    [:movies_as_actor, :movies_as_director, :movies_as_producer].each do |key|
      person_params[key].each do |movie_id|
        movie = Movie.find_by(id: movie_id)
        person.send(key) << movie if movie
      end
    end
    
    if person.save!
      render json: {message: "Person #{person.name} created"}
    else
      render json: {message: "Person #{person.name} not created"}
    end
  end

  def update
    if @person&.update_attributes!(person_attributes)
      [:movies_as_actor, :movies_as_director, :movies_as_producer].each do |key|
        @person.send(key).delete_all #remove associated movies to person
        person_params[key].each do |movie_id|
          movie = Movie.find_by(id: movie_id)
          @person.send(key) << Movie.find_by(id: movie_id)
        end
      end
      render json: {message: "Person #{@person.name} updated"}
    else
      render json: {message: "Person with id #{params[:id]} not updated"}
    end
  end

  def destroy
    if @person
      @person.destroy 
      render json: {message: "Person #{@person.name} deleted"}
    else
      render json: {message: "Person with id #{params[:id]} does not exist"}
    end
  end

  private

  def get_person
    @person = Person.find_by(id: params[:id])
  end

  def person_attributes
    person_params.permit(:first_name, :last_name, :aliases)
  end

  def person_params
    params.require(:person)
  end
end