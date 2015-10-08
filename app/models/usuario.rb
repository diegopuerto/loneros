class Usuario < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  # Validaciones
  validates_presence_of :nombre, :email, :celular
  validates_uniqueness_of :email
  validates :reputacion,
       numericality: { greater_than_or_equal_to: 0, only_integer: true  }
end
