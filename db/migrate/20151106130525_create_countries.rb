class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :code, :length => 2
      t.string :name
      t.boolean :point_of_sale
    end
	add_index :countries, :code, :unique => true
  end
end
