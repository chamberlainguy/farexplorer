class CreateSegs < ActiveRecord::Migration
  def change
    create_table :segs do |t|
      t.datetime :depart_datetime
      t.datetime :arrive_datetime
      t.integer :stop_quantity
      t.text 	:flight_num
      t.text 	:depart_airport_code, length: 3	
      t.text 	:arrive_airport_code, length: 3
      t.integer :flight_mins
      t.text 	:mark_airline_code, length: 2
      t.text 	:op_airline_code, length:  2
      t.integer :leg_id
      t.timestamps null: false
    end
  end
end
