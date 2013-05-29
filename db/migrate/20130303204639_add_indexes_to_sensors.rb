#migration for enforcing uniqueness of attributes in the database
class AddIndexesToSensors < ActiveRecord::Migration
  def change
    add_index :sensors, :ecn
    add_index :sensors, :mcn
    add_index :sensors, :serial
  end
end
