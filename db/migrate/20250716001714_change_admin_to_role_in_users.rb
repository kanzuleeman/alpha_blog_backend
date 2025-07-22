class ChangeAdminToRoleInUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :admin, :boolean
    add_column :users, :role, :string
  end
end
