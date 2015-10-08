class UsuarioSerializer < ActiveModel::Serializer
  attributes :id,
    :nombre,
    :imagen,
    :reputacion,
    :celular,
    :email
end
