class CreateAirlines < ActiveRecord::Migration
  def change
    create_table :airlines do |t|
	  t.string :code, :length => 2
      t.string :name
    end
	add_index :airlines, :code, :unique => true
  end
end
