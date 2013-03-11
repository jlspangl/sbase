class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.string :type
      t.string :ecn
      t.string :mcn
      t.string :model
      t.integer :serial_no

      t.timestamps
    end
  end
end
