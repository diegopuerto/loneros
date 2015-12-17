class AddCiudadToPedidos < ActiveRecord::Migration
  def up
    add_column :pedidos, :ciudad, :string, :null => false, :default => "ciudad"
  end
  def down
    remove_column :pedidos, :ciudad
  end
end
