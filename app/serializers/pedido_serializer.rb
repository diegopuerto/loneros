class PedidoSerializer < ActiveModel::Serializer
  attributes :id,
  	:direccion,
    :ciudad,
  	:comprobante_pago,
  	:numero_guia,
  	:estado,
  	:distribuidor_id,
  	:proveedor_id,
  	:costo_total,
    :created_at,
    :updated_at
	
	#Asociaciones
	has_many :productos
end
