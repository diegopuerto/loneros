class PreciosController < ApplicationController
  before_action :establecer_producto_precio, only: [:destroy, :update]

  # GET /usuarios/:usuario_id/productos/:producto_id/precios
  def index
  	@producto = Producto.find(params[:producto_id])
    # Actualizar colección de productos
    @producto.precios.reload
    render json: @producto.precios
  end

  # POST /usuarios/:usuario_id/productos/:producto_id/precio
  def create
    producto = Producto.find(params[:producto_id])
    precio = producto.precios.new(parametros_precio)
    if precio.save
      render json: precio, status: :created
    else
      render json: {:errors => {precio: ["No se ha podido agregar precio"]}}, status: :unprocessable_entity
    end
  end

  # DELETE /usuarios/:usuario_id/productos/:producto_id/precios/:id
  def destroy
    @producto.precios.destroy(@precio)
    head :no_content
  end

  # PATCH/PUT /usuarios/:usuario_id/productos/:producto_id/precios/:id
	def update
    @producto.precios.find(@precio.id).update(parametros_precio)
    head :no_content
  end

private
  def parametros_precio
    params.permit(:precio,
       	 :cantidad_minima)
  end

  def establecer_producto_precio
    @producto = Producto.find(params[:producto_id])
    @precio = Precio.find(params[:id])
  end
end
