class ProductoSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
    :descripcion

    
    #Asociaciones
    has_many :precios
    has_many :caracteristicas
    has_many :imagenes
    has_many :categorias
end
