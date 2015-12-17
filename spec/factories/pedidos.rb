FactoryGirl.define do
factory :pedido do
  direccion "MyString"
  ciudad "ciudad del pedido"
  comprobante_pago "MyString"
  numero_guia "MyString"
  costo_total "9.99"
  estado 1
  distribuidor nil
  proveedor nil
 end

 factory :pedido_uno, class: Pedido do
  direccion "direccion_uno"
  ciudad "ciudad del pedido uno"
  comprobante_pago "comprobante_uno"
  numero_guia "guia_uno"
  costo_total "9.99"
  estado 1
  distribuidor nil
  proveedor nil
 end

 factory :pedido_dos, class: Pedido do
  direccion "direccion_dos"
  ciudad "ciudad del pedido dos"
  comprobante_pago "comprobante_dos"
  numero_guia "guia_dos"
  costo_total "19.99"
  estado 1
  distribuidor nil
  proveedor nil
 end

 factory :pedido_tres, class: Pedido do
  direccion "direccion_tres"
  ciudad "ciudad del pedido tres"
  comprobante_pago "comprobante_tres"
  numero_guia "guia_tres"
  costo_total "29.99"
  estado 1
  distribuidor nil
  proveedor nil
 end

end
