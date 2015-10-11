require 'rails_helper'

RSpec.describe Caracteristica, type: :model do
   it "es valido con todos sus datos" do 
		@caracteristica = FactoryGirl.build(:caracteristica)
		expect(@caracteristica).to be_valid
  end

 	describe "Atributos requeridos" do
		it "Es inválido sin nombre" do
		  	@caracteristica = FactoryGirl.build(:caracteristica, nombre: nil)
		  	@caracteristica.valid?
		  	expect(@caracteristica.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
		end

		it "Es invalido sin valor" do
			@caracteristica = FactoryGirl.build(:caracteristica, valor: nil)
	  		#expect(@producto.valid?).to be false
	  		@caracteristica.valid?
	  		expect(@caracteristica.errors[:valor]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores Atributos" do
		it "Es inválido si el nombre tiene mas de 100 caracteres" do
            @caracteristica = FactoryGirl.build(:caracteristica, nombre: "a"*101)
            @caracteristica.valid?
            expect(@caracteristica.errors[:nombre]).to include(I18n.t 'errors.messages.too_long', count: 100)
        end

        it "Es inválido si el valor tiene mas de 100 caracteres" do
            @caracteristica = FactoryGirl.build(:caracteristica, valor: "a"*101)
            @caracteristica.valid?
            expect(@caracteristica.errors[:valor]).to include(I18n.t 'errors.messages.too_long', count: 100)
        end
    end

end
