class AddReferenciaToProducto < ActiveRecord::Migration
  def change
    add_column :productos, :referencia, :string
  end
end
