class Producto < ActiveRecord::Base
	#Asociaciones	
	has_many :precios, dependent: :destroy
	has_many :caracteristicas, dependent: :destroy
	has_many :imagenes, dependent: :destroy
	has_many :categorias_productos
        has_many :categorias, through: :categorias_productos, dependent: :destroy
	belongs_to :usuario

	#Validaciones
	validates_presence_of :nombre
	validates_presence_of :descripcion
        validates_presence_of :usuario

	validates :nombre, length: { maximum: 100 }
	validates :descripcion, length: { maximum: 1000 }
end
