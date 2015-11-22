class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
  	  t.string :code, :length => 2
      t.string :name
      t.string :country_id
    end
	add_index :taxes, :code, :unique => true
  end
end
