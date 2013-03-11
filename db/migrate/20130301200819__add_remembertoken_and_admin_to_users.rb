class AddRemembertokenAndAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
    add_column :users, :admin, :boolean, default: false
    remove_column :users, :name
  end
end
