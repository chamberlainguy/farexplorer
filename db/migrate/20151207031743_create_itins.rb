class CreateItins < ActiveRecord::Migration
  def change
    create_table :itins do |t|
      t.text :ticket_type
      t.decimal :price	
      t.text :curr_code, length: 3
      t.integer :bfsession_id
      t.timestamps null: false
    end
  end
end
