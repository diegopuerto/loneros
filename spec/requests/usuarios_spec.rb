require 'rails_helper'

RSpec.describe "Usuarios", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
    @usuario_dos = FactoryGirl.create :usuario_dos
  end

  # index
  describe "GET /usuarios" do
    it "Devuelve todos los usuarios" do
      get "/usuarios", {}, @cabeceras_peticion

      expect(response.status).to eq 200 # OK

      body = JSON.parse(response.body)
      usuarios = body['usuarios']
      nombres_usuario = usuarios.map { |m| m["nombre"] }
      emails_usuario = usuarios.map { |m| m["email"] }
      reputaciones_usuario = usuarios.map { |m| m["reputacion"] }
      celulares_usuario = usuarios.map { |m| m["celular"] }
      imagenes_usuario = usuarios.map { |m| m["imagen"] }

      expect(nombres_usuario).to match_array([@usuario_uno.nombre, @usuario_dos.nombre])
      expect(emails_usuario).to match_array([@usuario_uno.email, @usuario_dos.email])
      expect(reputaciones_usuario).to match_array([@usuario_uno.reputacion, @usuario_dos.reputacion])
      expect(celulares_usuario).to match_array([@usuario_uno.celular, @usuario_dos.celular])
      expect(imagenes_usuario).to match_array([@usuario_uno.imagen, @usuario_dos.imagen])
    end
  end

  # show
  describe "GET /usuarios/:id" do
    it "Devuelve el usuario solicitado" do
      get "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion
      expect(response.status).to be 200 # OK

      body = JSON.parse(response.body)
      usuario = body['usuario']

      expect(usuario["email"]).to eq @usuario_uno.email
      expect(usuario["nombre"]).to eq @usuario_uno.nombre
      expect(usuario["reputacion"]).to eq @usuario_uno.reputacion
      expect(usuario["celular"]).to eq @usuario_uno.celular
      expect(usuario["imagen"]).to eq @usuario_uno.imagen
    end
  end

  # destroy
  describe "DELETE /usuarios/:id" do
    it "Elimina un usuario" do
      delete "/usuarios/#{@usuario_uno.id}", {}, @cabeceras_peticion

      expect(response.status).to be 204 # No Content
      expect(Usuario.exists?(@usuario_uno.id)).to eq false
    end
  end

  # create
  describe "POST /usuarios" do
    it "Crea un usuario" do
      parametros_usuario = FactoryGirl.attributes_for(:usuario_valido).to_json
      usuario_valido = FactoryGirl.build :usuario_valido

      post "/usuarios", parametros_usuario, @cabeceras_peticion

      expect(response.status).to eq 201 # Created
      expect(Usuario.last.email).to eq usuario_valido.email
      expect(Usuario.last.nombre).to eq usuario_valido.nombre
      expect(Usuario.last.imagen).to eq usuario_valido.imagen
      expect(Usuario.last.celular).to eq usuario_valido.celular
    end
  end

  # update
  describe "PUT /usuarios/:id" do
    it "Actualiza un usuario" do
      parametros_usuario = FactoryGirl.attributes_for(:usuario_valido).to_json
      usuario_valido = FactoryGirl.build :usuario_valido

      put "/usuarios/#{@usuario_uno.id}", parametros_usuario, @cabeceras_peticion

      expect(response.status).to be 204 # No content
      expect(Usuario.find(@usuario_uno.id).email).to eq usuario_valido.email
      expect(Usuario.find(@usuario_uno.id).nombre).to eq usuario_valido.nombre
      expect(Usuario.find(@usuario_uno.id).imagen).to eq usuario_valido.imagen
      expect(Usuario.find(@usuario_uno.id).celular).to eq usuario_valido.celular
      # Este atributo no se puede editar
      expect(Usuario.find(@usuario_uno.id).reputacion).to eq @usuario_uno.reputacion
    end
  end
end
