class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.string :nombre, null: false
      t.text :descripcion

      t.timestamps null: false
    end
  end
end
