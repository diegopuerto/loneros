require 'rails_helper'

RSpec.describe Producto, type: :model do
  it "es valido con todos sus datos" do 
		@producto = FactoryGirl.build(:producto)
		expect(@producto).to be_valid
  end

  	describe "Atributos requeridos" do
		it "Es invalido sin nombre" do
			@producto = FactoryGirl.build(:producto, nombre: nil)
	  		#expect(@producto.valid?).to be false
	  		@producto.valid?
	  		expect(@producto.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
		end
		it "es inválido sin descripcion" do
		  	@producto = FactoryGirl.build(:producto, descripcion: nil)
		  	@producto.valid?
		  	expect(@producto.errors[:descripcion]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores de atributos" do

		it "es inválido si el nombre tiene más de 100 caracteres" do
  			@producto = FactoryGirl.build(:producto, nombre: "a"*101)
	  		@producto.valid?
	  		expect(@producto.errors[:nombre]).to include(I18n.t 'errors.messages.too_long', count: 100)
  		end

  		it "es inválido si la descripcion tiene más de 1000 caracteres" do
  			@producto = FactoryGirl.build(:producto, descripcion: "a"*1001)
	  		@producto.valid?
	  		expect(@producto.errors[:descripcion]).to include(I18n.t 'errors.messages.too_long', count: 1000)
  		end
  	end
end





