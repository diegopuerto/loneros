class ProductosController < ApplicationController
	before_action :establecer_producto, only: [:show, :destroy, :update]
  before_action :establecer_usuario_producto, only: [:destroy, :update]


  # GET /usuarios/:usuario_id/productos
  # GET /productos
  def index
    if params[:usuario_producto]
      @usuario = Usuario.find(params[:usuario_id])
      render json: @usuario.productos
    else
      @productos = Producto.all
      render json: @productos
    end
  end

  # GET /usuarios/:usuario_id/productos/:id
  # GET /productos/:id
  def show
    if params[:usuario_producto]
      @usuario = Usuario.find(params[:usuario_id])
      @producto = Producto.find(params[:id])
      render json: @usuario.productos.find(@producto.id)
    else
  	  @producto = Producto.find(params[:id])
      render json: @producto
    end
  end

  # DELETE /usuarios/:usuario_id/productos/:id
  def destroy
    @usuario.productos.destroy(@producto)
    head :no_content
  end

  # POST /usuarios/:usuario_id/productos
  def create
    # if params[:usuario_producto]
    @usuario = Usuario.find(params[:usuario_id])
    @producto = @usuario.productos.new(parametros_producto)
    if @producto.save
      render json: @usuario.productos, status: :created
    else
      render json: @producto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/:usuario_id/productos/:id
  def update
    up = @usuario.productos.find(@producto.id)
    if up.update(parametros_producto)
      head :no_content
    else
      render json: @usuario.productos.errors, status: :unprocessable_entity
    end    
  end

private
	def establecer_producto
  		@producto = Producto.find(params[:id])
	end

	def parametros_producto
    	params.permit(:nombre,
       	:descripcion)
  end

  def establecer_usuario_producto
    @usuario = Usuario.find(params[:usuario_id])
    @producto = Producto.find(params[:id])
  end
end
