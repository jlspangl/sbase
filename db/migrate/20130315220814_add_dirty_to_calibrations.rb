class AddDirtyToCalibrations < ActiveRecord::Migration
  def change
    add_column :calibrations, :dirty, :boolean, :default => true
  end
end
