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

  factory :usuario_uno, class: Usuario do
    uid "usuario_uno@correo.com"
    provider "email"
    password "clave secreta"
    nombre "Usuario Uno"
    email "usuario_uno@correo.com"
    reputacion 3000
    celular "3044533334"
    imagen "imagen_uno.png"
  end

  factory :usuario_dos, class: Usuario do
    uid "usuario_dos@correo.com"
    provider "email"
    password "clave secreta"
    nombre "Usuario Dos"
    email "usuario_dos@correo.com"
    reputacion 30
    celular "3022222234"
    imagen "imagen_dos.png"
  end

end
