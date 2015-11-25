class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.string :direccion, null: false
      t.string :comprobante_pago
      t.string :numero_guia
      t.decimal :costo_total, null: false
      t.integer :estado, :default => 0
      t.integer :distribuidor_id, index: true, foreign_key: true
      t.integer :proveedor_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
