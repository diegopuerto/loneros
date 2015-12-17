require 'rails_helper'

RSpec.describe "Auth", type: :request do

  before :each do
    @cabeceras_peticion = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
  end

  # Registro
  describe "POST /auth" do
    it "Crea un nuevo usuario" do
      parametros_usuario = FactoryGirl.attributes_for(:usuario_valido)
      usuario_nuevo = FactoryGirl.build :usuario_valido

      post "/auth", parametros_usuario.to_json, @cabeceras_peticion

      expect(response.status).to eq 200 # OK
      expect(Usuario.last.uid).to eq usuario_nuevo.uid
      expect(Usuario.last.provider).to eq usuario_nuevo.provider
      expect(Usuario.last.nombre).to eq usuario_nuevo.nombre
      expect(Usuario.last.email).to eq usuario_nuevo.email
      expect(Usuario.last.celular).to eq usuario_nuevo.celular
      expect(Usuario.last.imagen).to eq usuario_nuevo.imagen
      expect(Usuario.last.nombre_marca).to eq usuario_nuevo.nombre_marca
      expect(Usuario.last.logo_marca).to eq usuario_nuevo.logo_marca
      expect(Devise::Encryptor.compare(Usuario, Usuario.last.encrypted_password, usuario_nuevo.password)).to be true
      expect(Usuario.last.reputacion).to eq 0
    end
  end

  # Eliminar Cuenta
  describe "DELETE /auth" do
    it "Elimina usuario autenticado" do
      usuario_nuevo = FactoryGirl.create :usuario_valido

      # Log In usuario_nuevo
      @cabeceras_peticion.merge! usuario_nuevo.create_new_auth_token

      delete "/auth", {}, @cabeceras_peticion

      expect(response.status).to eq 200 # OK
      expect(Usuario.exists?(usuario_nuevo.id)).to be false
    end
  end

  # Actualizar Cuenta
  describe "PUT /auth" do
    it "Actualiza datos de usuario" do
      usuario = FactoryGirl.create :usuario_uno
      usuario_nuevo = FactoryGirl.build :usuario_valido
      parametros_usuario = FactoryGirl.attributes_for :usuario_valido

      # Log In usuario_nuevo
      @cabeceras_peticion.merge! usuario.create_new_auth_token

      put "/auth", parametros_usuario.to_json, @cabeceras_peticion

      expect(response.status).to eq 200 # OK
      expect(Usuario.find(usuario.id).nombre).to eq usuario_nuevo.nombre
      expect(Usuario.find(usuario.id).email).to eq usuario_nuevo.email
      expect(Usuario.find(usuario.id).celular).to eq usuario_nuevo.celular
      expect(Usuario.find(usuario.id).imagen).to eq usuario_nuevo.imagen
      expect(Usuario.find(usuario.id).nombre_marca).to eq usuario_nuevo.nombre_marca
      expect(Usuario.find(usuario.id).logo_marca).to eq usuario_nuevo.logo_marca
      expect(Devise::Encryptor.compare(Usuario, Usuario.find(usuario.id).encrypted_password, usuario_nuevo.password)).to be true
    end
  end

  ## Iniciar Sesión
  #describe "POST /auth/sign_in" do
    #it "Inicia sesión de usuario"
  #end

  ## Cerrar Sesión
  #describe "DELETE /auth/sign_out" do
    #it "Cierra sesión de usuario"
  #end

  ## Validar Token
  #describe "GET /auth/validate_token" do
    #it "Valida token de usuario"
  #end

  ## Enviar correo de confirmación de cambio de contraseña
  #describe "POST /auth/password" do
    #it "Envía correo de confirmación de cambio de contraseña"
  #end

  # Actualizar contraseña
  describe "PUT /auth/password" do
    it "Actualiza contraseña de usuario autenticado" do
      usuario = FactoryGirl.create :usuario_uno
      usuario_nuevo = FactoryGirl.build :usuario_valido

      parametros_usuario = { password: usuario_nuevo.password, password_confirmation: usuario_nuevo.password }
      # Log In usuario_nuevo
      @cabeceras_peticion.merge! usuario.create_new_auth_token

      put "/auth/password", parametros_usuario.to_json, @cabeceras_peticion

      expect(response.status).to eq 200 # OK
      expect(Devise::Encryptor.compare(Usuario, Usuario.find(usuario.id).encrypted_password, usuario_nuevo.password)).to be true
    end
  end

  ## Autenticar Usuario por password_reset_token
  #describe "GET /auth/password/edit" do
    #it "Autentica usuario a partir del password_reset_token"
  #end

end
