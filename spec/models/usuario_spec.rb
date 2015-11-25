require 'rails_helper'

RSpec.describe Usuario, type: :model do

  before :each do
    @usuario = FactoryGirl.create :usuario_valido
  end

  context "Atributos Válidos" do
    it "es válido con nombre, correo y celular" do
      expect(@usuario).to be_valid
    end
  end

  context "Atributos no Válidos" do

    it "no es válido sin nombre" do
      @usuario.nombre = nil
      @usuario.valid?
      expect(@usuario.errors[:nombre]).to include("can't be blank")
    end

    it "no es válido sin email" do
      @usuario.email = nil
      @usuario.valid?
      expect(@usuario.errors[:email]).to include("can't be blank")
    end

    it "no es válido sin celular" do
      @usuario.celular = nil
      @usuario.valid?
      expect(@usuario.errors[:celular]).to include("can't be blank")
    end

    it "no es valido sin nombre_marca" do 
      @usuario.nombre_marca = nil
      @usuario.valid?
      expect(@usuario.errors[:nombre_marca]).to include("can't be blank")
    end

    it "no es valido sin direccion" do 
      @usuario.direccion = nil
      @usuario.valid?
      expect(@usuario.errors[:direccion]).to include("can't be blank")
    end

    it "no es válido si el correo no es único" do
      usuario_duplicado = @usuario.dup
      usuario_duplicado.valid?
      @usuario.valid?
      expect(usuario_duplicado.errors[:email]).to include("This email address is already in use")
    end

    it "no es válido si la reputación es negativa" do
      @usuario.reputacion = -10
      @usuario.valid?
      expect(@usuario.errors[:reputacion]).to include("must be greater than or equal to 0")
    end

    it "no es válido si la reputación no es un entero" do
      @usuario.reputacion = 10.43
      @usuario.valid?
      expect(@usuario.errors[:reputacion]).to include("must be an integer")
    end
  end
end
