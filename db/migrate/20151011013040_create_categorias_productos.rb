class CreateCategoriasProductos < ActiveRecord::Migration
  def change
    create_table :categorias_productos do |t|
      t.references :producto, index: true, foreign_key: true
      t.references :categoria, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
