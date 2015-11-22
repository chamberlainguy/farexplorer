class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :country
      t.string :currency
      t.string :code
      t.string :symbol
    end
    add_index :currencies, :code, :unique => true
  end
end
