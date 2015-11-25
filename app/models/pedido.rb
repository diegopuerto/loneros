class Pedido < ActiveRecord::Base

  # Asociaciones
  belongs_to :distribuidor, :class_name => "Usuario"
  belongs_to :proveedor, :class_name => "Usuario"
  has_many :pedidos_productos
  has_many :productos, through: :pedidos_productos

  # Estados del pedido
  enum estado: [ :nuevo, :rechazado, :pendiente_pago, :pagado, :enviado, :recibido ]

  # nested attributes
  accepts_nested_attributes_for :pedidos_productos, allow_destroy: true

  # Validaciones
  validates_presence_of :direccion
  validates_presence_of :costo_total
  validates_presence_of :estado
  validates :direccion, length: { maximum: 100 }
  validates :costo_total,
         numericality: { greater_than_or_equal_to: 0 }
end
