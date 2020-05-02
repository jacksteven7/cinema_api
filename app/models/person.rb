class Person < ApplicationRecord
  has_many :actors
  has_many :directors
  has_many :producers
  has_many :movies_as_actors, through: :actors, source: :movie
  has_many :movies_as_directors, through: :directors, source: :movie
  has_many :movies_as_producers, through: :producers, source: :movie
end
