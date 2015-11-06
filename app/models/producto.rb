class Producto < ActiveRecord::Base
	#Asociaciones	
	has_many :precios, dependent: :destroy
	has_many :caracteristicas, dependent: :destroy
	has_many :imagenes, dependent: :destroy
	has_many :categorias_productos
        has_many :categorias, through: :categorias_productos, dependent: :destroy
	belongs_to :usuario
        has_many :pedidos_productos
        has_many :pedidos, through: :pedidos_productos

	# nested attributes
	accepts_nested_attributes_for :precios, allow_destroy: true
	accepts_nested_attributes_for :caracteristicas, allow_destroy: true
	accepts_nested_attributes_for :imagenes, allow_destroy: true
	
	#Validaciones
	validates_presence_of :nombre
	validates_presence_of :descripcion
        validates_presence_of :usuario

	validates :nombre, length: { maximum: 100 }
	validates :descripcion, length: { maximum: 1000 }
end
