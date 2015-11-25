class UsuariosController < ApplicationController

  before_action :establecer_usuario, only: [:show, :destroy, :update]
  authorize_resource

  # GET /usuarios
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

  # GET /usuarios/1
  def show
    render json: @usuario
  end

  # DELETE /usuarios/1
  def destroy
    @usuario.destroy
    head :no_content
  end

  # POST /usuarios
  def create
    @usuario = Usuario.new(parametros_crear_usuario)

    if @usuario.save
      render json: @usuario, status: :created
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/1
  def update
    if @usuario.update(parametros_editar_usuario)
      head :no_content
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  private

    def establecer_usuario
      @usuario = Usuario.find(params[:id])
    end

    def parametros_crear_usuario
      params.permit(:email,
       :password,
       :uid,
       :provider,
       :nombre,
       :nombre_marca,
       :logo_marca,
       :direccion,
       :imagen,
       :celular)
    end

    def parametros_editar_usuario
    	params.permit(:email,
    		:nombre,
    		:imagen,
        :nombre_marca,
        :logo_marca,
        :direccion,
    		:celular)
    end

end
