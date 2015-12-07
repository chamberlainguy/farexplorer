class CreateItinsLegs < ActiveRecord::Migration
  def change
    create_table :itins_legs do |t|
      t.integer :itin_id, index: true
      t.integer :leg_id, index: true
    end
  end
end
