class AddUsuarioRefToProductos < ActiveRecord::Migration
  def change
    add_reference :productos, :usuario, index: true, foreign_key: true
  end
end
