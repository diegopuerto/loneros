class Caracteristica < ActiveRecord::Base
  belongs_to :producto

  #Validaciones
	validates_presence_of :nombre
	validates_presence_of :valor
	validates :nombre, length: { maximum: 100 }
	validates :valor, length: { maximum: 100 }
end
