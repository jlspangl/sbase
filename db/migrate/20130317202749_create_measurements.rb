class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :sensor_id
      t.integer :calibration_id
      t.integer :position

      t.timestamps
    end
    add_index :measurements, :sensor_id
    add_index :measurements, :calibration_id
    # composite index that enforces uniqueness of pairs
    add_index :measurements, [:sensor_id, :calibration_id], unique: true
  end
end
