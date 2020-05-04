class PeopleController < ApplicationController
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
    person = Person.create(first_name: person_params[:first_name], last_name: person_params[:last_name], aliases: person_params[:aliases])
    [:movies_as_actor, :movies_as_director, :movies_as_producer].each do |key|
      person_params[key].each do |movie_id|
        person.send(key) << Movie.find_by(id: movie_id)
      end
    end
    render json: {message: "Person #{person.name} created"}
  end

  def update
    person = Person.find_by(id: params[:id])
    person.update_attributes!(person_attributes)
    [:movies_as_actor, :movies_as_director, :movies_as_producer].each do |key|
      person.send(key).delete_all #remove associated movies to person
      person_params[key].each do |movie_id|
        person.send(key) << Movie.find_by(id: movie_id)
      end
    end
    render json: {message: "Person #{person.name} updated"}
  end

  def destroy
    person = Person.find_by(id: params[:id])
    person.destroy 
    render json: {message: "Person #{person.name} deleted"}
  end

  private

  def person_attributes
    person_params.permit(:first_name, :last_name, :aliases)
  end

  def person_params
    params.require(:person)
  end
end