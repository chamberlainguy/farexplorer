class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.string :code, :length => 3
      t.string :name
      t.string :country_id
    end
	add_index :aircrafts, :code, :unique => true
  end
end
