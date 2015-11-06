FactoryGirl.define do
factory :pedido do
  direccion "MyString"
  comprobante_pago "MyString"
  numero_guia "MyString"
  costo_total "9.99"
  estado 1
  distribuidor nil
  proveedor nil
  factura nil
 end

 factory :pedido_uno, class: Pedido do
  direccion "direccion_uno"
  comprobante_pago "comprobante_uno"
  numero_guia "guia_uno"
  costo_total "9.99"
  estado 1
  distribuidor nil
  proveedor nil
  factura nil
 end

 factory :pedido_dos, class: Pedido do
  direccion "direccion_dos"
  comprobante_pago "comprobante_dos"
  numero_guia "guia_dos"
  costo_total "19.99"
  estado 1
  distribuidor nil
  proveedor nil
  factura nil
 end

 factory :pedido_tres, class: Pedido do
  direccion "direccion_tres"
  comprobante_pago "comprobante_tres"
  numero_guia "guia_tres"
  costo_total "29.99"
  estado 1
  distribuidor nil
  proveedor nil
  factura nil
 end

end
