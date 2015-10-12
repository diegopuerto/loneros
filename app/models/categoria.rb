class Categoria < ActiveRecord::Base
	#Asociaciones
	has_many :categorias_productos
        has_many :productos, through: :categorias_productos


	#Validaciones
	validates_presence_of :nombre
	validates :nombre, length: { maximum: 100 }
end
