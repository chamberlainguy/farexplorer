class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
 	  t.string :code, :length => 3
      t.string :name
      t.string :country_id
    end
	add_index :cities, :code, :unique => true
	add_index :cities, :name, :unique => false
  end
end
