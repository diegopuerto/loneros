class CreateCaracteristicas < ActiveRecord::Migration
  def change
    create_table :caracteristicas do |t|
      t.string :nombre, null: false
      t.string :valor, null: false
      t.references :producto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
