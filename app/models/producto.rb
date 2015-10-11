class Producto < ActiveRecord::Base
	has_many :precios, dependent: :destroy
	has_many :caracteristicas, dependent: :destroy
	has_many :imagenes, dependent: :destroy

	#Validaciones
		validates_presence_of :nombre
		validates_presence_of :descripcion

		validates :nombre, length: { maximum: 100 }
		validates :descripcion, length: { maximum: 1000 }
end
