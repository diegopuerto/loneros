class AddMarcaDireccionToUsuarios < ActiveRecord::Migration
  def change
	add_column :usuarios, :nombre_marca, :string
	add_column :usuarios, :logo_marca, :string
	add_column :usuarios, :direccion, :string

	change_column :usuarios, :nombre_marca, :string, :null => false
	change_column :usuarios, :direccion, :string, :null => false
  end
end
