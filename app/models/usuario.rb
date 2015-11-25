class Usuario < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Validaciones
  validates_presence_of :nombre, :email, :celular, :nombre_marca, :direccion
  validates_uniqueness_of :email
  validates :reputacion,
       numericality: { greater_than_or_equal_to: 0, only_integer: true  }

  #Asociaciones
  has_many :productos, dependent: :destroy
  has_many :pedidos_distribuidor, :foreign_key => "distribuidor_id", :class_name => "Pedido"
  has_many :pedidos_proveedor, :foreign_key => "proveedor_id", :class_name => "Pedido"

  def signed_in?
    self.nombre != nil
  end

end
