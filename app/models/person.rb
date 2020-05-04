class Person < ApplicationRecord
  has_many :actors, dependent: :destroy
  has_many :directors, dependent: :destroy
  has_many :producers, dependent: :destroy
  has_many :movies_as_actor, through: :actors, source: :movie
  has_many :movies_as_director, through: :directors, source: :movie
  has_many :movies_as_producer, through: :producers, source: :movie


  def name
    self.first_name + " " + self.last_name
  end
end
