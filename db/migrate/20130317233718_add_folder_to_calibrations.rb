class AddFolderToCalibrations < ActiveRecord::Migration
  def change
    #relative pathname of directory in which the calibration spreadsheet is saved
    add_column :calibrations, :folder, :string
  end
end
