class CreateImagenes < ActiveRecord::Migration
  def change
    create_table :imagenes do |t|
      t.string :public_id, null: false
      t.references :producto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
