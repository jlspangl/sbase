class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :sensors, :type, :category
  end
end
