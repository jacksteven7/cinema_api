class CreateProducers < ActiveRecord::Migration[5.2]
  def change
    create_table :producers do |t|
      t.integer   :person_id
      t.integer   :movie_id
      
      t.timestamps
    end
  end
end
