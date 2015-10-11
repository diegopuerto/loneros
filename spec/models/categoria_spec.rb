require 'rails_helper'

RSpec.describe Categoria, type: :model do
   it "es valido con todos sus datos" do 
		@categoria = FactoryGirl.build(:categoria)
		expect(@categoria).to be_valid
  end

  	describe "Atributos requeridos" do
		it "Es inválido sin nombre" do
		  	@categoria = FactoryGirl.build(:categoria, nombre: nil)
		  	@categoria.valid?
		  	expect(@categoria.errors[:nombre]).to include(I18n.t 'errors.messages.blank')
		end
	end

	describe "Valores Atributos" do
		it "Es inválido si el nombre tiene mas de 100 caracteres" do
            @categoria = FactoryGirl.build(:categoria, nombre: "a"*101)
            @categoria.valid?
            expect(@categoria.errors[:nombre]).to include(I18n.t 'errors.messages.too_long', count: 100)
        end
    end
end
