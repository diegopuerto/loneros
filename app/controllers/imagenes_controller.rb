class ImagenesController < ApplicationController
   before_action :establecer_producto_imagen, only: [:destroy, :update]

  # GET /usuarios/:usuario_id/productos/:producto_id/imagenes
  def index
  	@producto = Producto.find(params[:producto_id])
    # Actualizar colección de productos
    @producto.imagenes.reload
    render json: @producto.imagenes
  end

  # POST /usuarios/:usuario_id/productos/:producto_id/imagenes
  def create
    producto = Producto.find(params[:producto_id])
    imagen = producto.imagenes.new(parametros_imagen)
    if imagen.save
      render json: imagen, status: :created
    else
      render json: {:errors => {precio: ["No se ha podido agregar imagen"]}}, status: :unprocessable_entity
    end
  end

  # DELETE /usuarios/:usuario_id/productos/:producto_id/imagenes/:id
  def destroy
    @producto.imagenes.destroy(@imagen)
    head :no_content
  end

  # PATCH/PUT /usuarios/:usuario_id/productos/:producto_id/imagenes/:id
	def update
    @producto.imagenes.find(@imagen.id).update(parametros_imagen)
    head :no_content
  end

private
  def parametros_imagen
    params.permit(:public_id)
  end

  def establecer_producto_imagen
    @producto = Producto.find(params[:producto_id])
    @imagen = Imagen.find(params[:id])
  end
end
