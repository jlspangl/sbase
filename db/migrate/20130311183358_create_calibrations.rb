class CreateCalibrations < ActiveRecord::Migration

  def change
    create_table :calibrations do |t|
      t.string :filename
      t.date :cal_date
      t.date :expiration_date
      t.float :range_max, :default => 0.0
      t.float :range_min, :default => 0.0
      t.integer :sensor_id

      t.timestamps
    end
    add_index :calibrations, [:sensor_id, :cal_date]
  end
end
