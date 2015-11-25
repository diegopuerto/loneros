require 'rails_helper'

RSpec.describe Pedido, type: :model do
   	it "es valido con todos sus datos" do 
		@pedido = FactoryGirl.build :pedido
		expect(@pedido).to be_valid
  	end

  	describe "Atributos requeridos" do
		it "es invalido sin direccion" do
			@pedido = FactoryGirl.build(:pedido, direccion: nil)
	  		@pedido.valid?
	  		expect(@pedido.errors[:direccion]).to include(I18n.t 'errors.messages.blank')
		end

		it "es invalido sin costo total" do 
			@pedido = FactoryGirl.build(:pedido, costo_total: nil)
	  		@pedido.valid?
	  		expect(@pedido.errors[:costo_total]).to include(I18n.t 'errors.messages.blank')
		end

		it "es invalido sin estado" do 
			@pedido = FactoryGirl.build(:pedido, estado: nil)
	  		@pedido.valid?
	  		expect(@pedido.errors[:estado]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores de atributos" do

		it "es inválido si la direccion tiene más de 100 caracteres" do
  			@pedido = FactoryGirl.build(:pedido, direccion: "a"*101)
	  		@pedido.valid?
	  		expect(@pedido.errors[:direccion]).to include(I18n.t 'errors.messages.too_long', count: 100)
  		end

  		it "es inválido si el costo total es menor que cero" do
  			@pedido = FactoryGirl.build(:pedido, costo_total: -200)
	  		@pedido.valid?
	  		expect(@pedido.errors[:costo_total]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
  		end
  	end
end
