class ProductosController < ApplicationController
	before_action :establecer_producto, only: [:show, :destroy, :update]
  before_action :establecer_usuario_producto, only: [:destroy, :update]
  authorize_resource

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
    @usuario = Usuario.find(params[:usuario_id])
    @producto = @usuario.productos.new(parametros_producto_crear)
    #@producto.categorias = params[:categorias]
    @categorias = []
    params[:categorias].each do |c|
      @categorias << Categoria.find_by(nombre: c[:nombre])
    end
    @producto.categorias << @categorias
    if @producto.save
      render json: @usuario.productos, status: :created
    else
      render json: @producto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/:usuario_id/productos/:id
  def update
    if params[:categorias]
      @categorias = []
      params[:categorias].each do |c|
        @categorias << Categoria.find_by(nombre: c[:nombre])
      end
      @producto.categorias.clear
      @producto.categorias << @categorias
    end
    if @producto.update(parametros_producto_actualizar)
      head :no_content
    else
      render json: @producto.errors, status: :unprocessable_entity
    end
  end

private
	def establecer_producto
  		@producto = Producto.find(params[:id])
	end

	def parametros_producto_crear
    	params.permit(:nombre,
       	:descripcion,
        :referencia,
        precios_attributes: [:precio, :cantidad_minima],
        caracteristicas_attributes: [:nombre, :valor],
        imagenes_attributes: [:public_id])
  end

  def parametros_producto_actualizar
      params.permit(:nombre,
        :descripcion,
        :referencia,
        precios_attributes: [:id, :precio, :cantidad_minima, :_destroy],
        caracteristicas_attributes: [:id, :nombre, :valor, :_destroy],
        imagenes_attributes: [:id, :public_id, :_destroy])
  end

  def establecer_usuario_producto
    #@usuario = Usuario.find(params[:usuario_id])
    @producto = Producto.find(params[:id])
    @usuario = @producto.usuario
  end
end
