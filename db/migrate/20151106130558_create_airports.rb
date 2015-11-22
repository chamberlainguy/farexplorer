class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :code, :length => 3
      t.string :name
      t.string :city_id
    end
	add_index :airports, :code, :unique => true
  end
end
