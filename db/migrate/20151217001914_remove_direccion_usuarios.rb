class RemoveDireccionUsuarios < ActiveRecord::Migration
  def up
    remove_column :usuarios, :direccion
    change_column :usuarios, :nombre_marca, :string, :null => true
  end
  def down
    add_column :usuarios, :direccion, :string, :null => false, :default => "loneros"
    change_column :usuarios, :nombre_marca, :string, :null => false, :default => "loneros"
  end
end
