class AddMarcaDireccionToUsuarios < ActiveRecord::Migration
  def up
    add_column :usuarios, :nombre_marca, :string, :null => false, :default => "loneros"
    add_column :usuarios, :logo_marca, :string
    add_column :usuarios, :direccion, :string, :null => false, :default => "loneros"
  end

  def down
    remove_column :usuarios, :nombre_marca
    remove_column :usuarios, :logo_marca
    remove_column :usuarios, :direccion
  end
end
