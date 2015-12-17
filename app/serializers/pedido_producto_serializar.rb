class PedidoProductoSerializer < ActiveModel::Serializer
  attributes :id,
    :cantidad,
    :precio

	#Asociaciones
  has_one :producto
end
