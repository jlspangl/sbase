class ChangeSerialNo < ActiveRecord::Migration
  def change
    change_column :sensors, :serial_no, :string
    rename_column :sensors, :serial_no, :serial
  end
end
