require 'rails_helper'

RSpec.describe Precio, type: :model do
  it "es valido con todos sus datos" do 
		@precio = FactoryGirl.build(:precio)
		expect(@precio).to be_valid
  end

  	describe "Atributos requeridos" do
		it "Es inválido sin precio" do
		  	@precio = FactoryGirl.build(:precio, precio: nil)
		  	@precio.valid?
		  	expect(@precio.errors[:precio]).to include(I18n.t 'errors.messages.blank')
		end

		it "Es invalido sin cantidad_minima" do
			@precio = FactoryGirl.build(:precio, cantidad_minima: nil)
	  		#expect(@producto.valid?).to be false
	  		@precio.valid?
	  		expect(@precio.errors[:cantidad_minima]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores Atributos" do
		it "Es inválido si el precio es menor que cero" do
            @precio = FactoryGirl.build(:precio, precio: -200)
            @precio.valid?
            expect(@precio.errors[:precio]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
        end

        it "Es inválido si la cantidad_minima es menor que cero" do
            @precio = FactoryGirl.build(:precio, cantidad_minima: -200)
            @precio.valid?
            expect(@precio.errors[:cantidad_minima]).to include(I18n.t 'errors.messages.greater_than_or_equal_to', count: 0)
        end
    end
end
