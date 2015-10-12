class ProductoSerializer < ActiveModel::Serializer
  attributes :id,
  	:nombre,
    :descripcion
end
