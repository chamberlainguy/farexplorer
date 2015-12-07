class CreateBfsessions < ActiveRecord::Migration
  def change
    create_table :bfsessions do |t|

      t.timestamps null: false
    end
  end
end
