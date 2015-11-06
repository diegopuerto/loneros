class CreatePedidosProductos < ActiveRecord::Migration
  def change
    create_table :pedidos_productos do |t|
      t.references :pedido, index: true, foreign_key: true
      t.references :producto, index: true, foreign_key: true
      t.decimal :cantidad
      t.decimal :precio

      t.timestamps null: false
    end
  end
end
