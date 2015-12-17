class PedidoSerializer < ActiveModel::Serializer
  attributes :id,
  	:direccion,
    :ciudad,
  	:comprobante_pago,
  	:numero_guia,
  	:estado,
  	:distribuidor_id,
  	:proveedor_id,
  	:costo_total
	
	#Asociaciones
	has_many :productos
end
