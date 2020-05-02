class PeopleController < ApplicationController
  def index
    people = Person.all
    people = people.map do |person|
      person.attributes.merge(
        'movies_as_actor' => person.movies_as_actors.map {|p| [p.id, p.title]},
        'movies_as_directors' => person.movies_as_directors.map {|p| [p.id, p.title]},
        'movies_as_producers' => person.movies_as_producers.map {|p| [p.id, p.title]} 
      )
    end
    render json: people
  end

  private

  def person_params
    params.require(:person).permit(:last_name, :first_name, :aliases, :movies_as_actor, :movies_as_director, :movies_as_producer)
  end
end