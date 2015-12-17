class UsuarioSerializer < ActiveModel::Serializer
  attributes :id,
    :nombre,
    :imagen,
    :reputacion,
    :celular,
    :email,
    :nombre_marca,
    :logo_marca
end
