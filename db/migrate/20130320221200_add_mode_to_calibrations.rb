class AddModeToCalibrations < ActiveRecord::Migration
  def change
    add_column :calibrations, :mode, :integer
  end
end
