class CreateCalibrations < ActiveRecord::Migration

  def change
    create_table :calibrations do |t|
      t.string :orig_filename
      t.string :measurement_unit
      # date calibration was done
      t.date :caldate
      # date calibration expires
      t.date :expdate
      t.float :calibration_max, :default => 0.0
      t.float :calibration_min, :default => 0.0
      t.float :range, :default => 0.0
      t.boolean :dirty, :default => true
      #relative pathname of directory in which the calibration spreadsheet is saved
      t.string :folder, :string
      t.integer :mode, :integer
      t.timestamps
    end
  end
end
