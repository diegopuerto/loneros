class CreatePrecios < ActiveRecord::Migration
  def change
    create_table :precios do |t|
      t.integer :cantidad_minima, null: false
      t.integer :precio, null: false
      t.belongs_to :producto, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
