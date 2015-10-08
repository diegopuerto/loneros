FactoryGirl.define do

  factory :usuario_valido, class: Usuario do
    uid "usuario@correo.com"
    provider "email"
    password "clave secreta"
    nombre "Usuario Válido"
    email "usuario@correo.com"
    reputacion 1000
    celular "3003453234"
    imagen "imagen.png"
  end

end
