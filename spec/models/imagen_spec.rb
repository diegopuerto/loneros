require 'rails_helper'

RSpec.describe Imagen, type: :model do
  	it "es valido con todos sus datos" do 
		@imagen = FactoryGirl.build(:imagen)
		expect(@imagen).to be_valid
    end

	describe "Atributos requeridos" do
		it "Es inválido sin public_id" do
		  	@imagen = FactoryGirl.build(:imagen, public_id: nil)
		  	@imagen.valid?
		  	expect(@imagen.errors[:public_id]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores Atributos" do
		it "Es inválido si el public_id tiene mas de 100 caracteres" do
            @imagen = FactoryGirl.build(:imagen, public_id: "a"*101)
            @imagen.valid?
            expect(@imagen.errors[:public_id]).to include(I18n.t 'errors.messages.too_long', count: 100)
        end
    end
end
