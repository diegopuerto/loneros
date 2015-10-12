class CaracteristicasController < ApplicationController

	# GET /productos/:producto_id/caracteristicas
  	def index
  		@producto = Producto.find(params[:producto_id])
    		# Actualizar colección de productos
    	@producto.caracteristicas.reload
    	render json: @producto.caracteristicas
  	end

  	# POST /productos/:producto_id/caracteristicas
  	def create
	    producto = Producto.find(params[:producto_id])
      	caracteristica = Caracteristica.find(params[:caracteristica_id])

     	if producto.caracteristicas << caracteristica
        	render json: caracteristica, status: :created
      	else
        	render json: {:errors => {caracteristica: ["No se ha podido agregar caracteristica"]}}, status: :unprocessable_entity
      	end
    end

    # DELETE /productos/:producto_id/caracteristicas/:id
  	def destroy
      	@producto = Producto.find(params[:producto_id])
      	@caracteristica = Caracteristica.find(params[:id])
      	@producto.caracteristicas.destroy(@caracteristica)
      	head :no_content
    end

    # PATCH/PUT /productos/:producto_id/caracteristicas/:id

	def update
		@producto = Producto.find(params[:producto_id])
      	@caracteristica = Caracteristica.find(params[:id])
      	@producto.caracteristicas.find(@caracteristica.id).update(parametros_caracteristica)
      	head :no_content
    end

private
    def parametros_caracteristica
    	params.permit(:nombre,
       	:valor)
    end
end

