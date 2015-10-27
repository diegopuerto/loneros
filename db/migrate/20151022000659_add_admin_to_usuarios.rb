class AddAdminToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :admin, :boolean, :null => false, :default => false
  end
end
