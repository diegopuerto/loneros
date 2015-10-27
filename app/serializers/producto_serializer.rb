class ProductoSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
    :descripcion,
    :referencia

    
    #Asociaciones
    has_many :precios
    has_many :caracteristicas
    has_many :imagenes
    has_many :categorias 
    has_one :usuario
end
