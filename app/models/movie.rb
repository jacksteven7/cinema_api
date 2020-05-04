class Movie < ApplicationRecord
  has_many :actors, dependent: :destroy
  has_many :directors, dependent: :destroy
  has_many :producers, dependent: :destroy
  has_many :actors_in_movie, through: :actors, source: :person
  has_many :directors_in_movie, through: :directors, source: :person
  has_many :producers_in_movie, through: :producers, source: :person
end
