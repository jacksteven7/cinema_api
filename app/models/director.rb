class Director < ApplicationRecord
    belongs_to :person
    belongs_to :movie
end
