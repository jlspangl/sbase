class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.string :category
      t.string :ecn
      t.string :mcn
      t.string :model
      t.string :serial
      t.string :tag

      t.timestamps
    end
    add_index :sensors, :ecn
    add_index :sensors, :mcn
    add_index :sensors, :serial
  end
end
