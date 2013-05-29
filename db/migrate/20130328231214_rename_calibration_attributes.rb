class RenameCalibrationAttributes < ActiveRecord::Migration
  def change
    rename_column :calibrations, :calibration_date, :caldate
    rename_column :calibrations, :expiration_date, :expdate
  end
end
