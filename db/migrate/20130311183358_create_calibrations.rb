class CreateCalibrations < ActiveRecord::Migration

  def change
    create_table :calibrations do |t|
      t.string :orig_filename
      t.string :measurement_unit
      t.date :calibration_date
      t.date :expiration_date
      t.float :calibration_max, :default => 0.0
      t.float :calibration_min, :default => 0.0
      t.float :range, :default => 0.0

      t.timestamps
    end
  end
end
