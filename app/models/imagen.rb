class Imagen < ActiveRecord::Base
  belongs_to :producto

  #Validaciones
	validates_presence_of :public_id
	validates :public_id, length: { maximum: 100 }
end
