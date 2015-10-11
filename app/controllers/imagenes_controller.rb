class ImagenesController < ApplicationController

	# GET /productos/:producto_id/imagenes
  	def index
  		@producto = Producto.find(params[:producto_id])
    		# Actualizar colección de productos
    	@producto.imagenes.reload
    	render json: @producto.imagenes
  	end

  	# POST /productos/:producto_id/precio
  	def create
	    producto = Producto.find(params[:producto_id])
      	imagen = Imagen.find(params[:imagen_id])

     	if producto.imagenes << imagen
        	render json: imagen, status: :created
      	else
        	render json: {:errors => {imagen: ["No se ha podido agregar imagen"]}}, status: :unprocessable_entity
      	end
    end

    # DELETE /productos/:producto_id/precios/:id
  	def destroy
      	@producto = Producto.find(params[:producto_id])
      	@imagen = Imagen.find(params[:id])
      	@producto.imagenes.destroy(@imagen)
      	head :no_content
    end

    # PATCH/PUT

	def update
		@producto = Producto.find(params[:producto_id])
      	@imagen = Imagen.find(params[:id])
      	@producto.imagenes.find(@imagen.id).update(parametros_imagen)
      	head :no_content
    end

private

    def parametros_imagen
    	params.permit(:public_id)
    end
end
