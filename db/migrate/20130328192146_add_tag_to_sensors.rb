class AddTagToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :tag, :string
  end
end
