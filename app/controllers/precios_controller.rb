class PreciosController < ApplicationController

# GET /productos/:producto_id/precios
  	def index
  		@producto = Producto.find(params[:producto_id])
    		# Actualizar colección de productos
    	@producto.precios.reload
    	render json: @producto.precios
  	end

# POST /productos/:producto_id/precio
  	def create
	    producto = Producto.find(params[:producto_id])
      	precio = Precio.find(params[:precio_id])

     	if producto.precios << precio
        	render json: precio, status: :created
      	else
        	render json: {:errors => {precio: ["No se ha podido agregar precio"]}}, status: :unprocessable_entity
      	end
    end

# DELETE /productos/:producto_id/precios/:id
  	def destroy
      	@producto = Producto.find(params[:producto_id])
      	@precio = Precio.find(params[:id])
      	@producto.precios.destroy(@precio)
      	head :no_content
    end

# PATCH/PUT

	def update
		@producto = Producto.find(params[:producto_id])
      	@precio = Precio.find(params[:id])
      	@producto.precios.find(@precio.id).update(parametros_precio)
      	head :no_content
    end

private

    def parametros_precio
    	params.permit(:precio,
       	:cantidad_minima)
    end
end
