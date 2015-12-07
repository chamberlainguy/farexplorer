class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      t.integer :seq
      t.text 	:search_key	
      t.integer :flight_mins
      t.integer :bfsession_id
      t.timestamps null: false
    end
    add_index :legs, :search_key, :unique => true
  end
end
