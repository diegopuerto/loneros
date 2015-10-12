class Precio < ActiveRecord::Base
	belongs_to :producto

	#Validaciones
	validates_presence_of :cantidad_minima
	validates_presence_of :precio
	validates :precio,
         numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validates :cantidad_minima,
         numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
