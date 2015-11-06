class PedidosController < ApplicationController

	load_and_authorize_resource

	# GET /pedidos
	def index
		@usuario = current_usuario
		if @usuario.admin?
			render json: @pedidos
		else
			render :json => {:distribuidor => @usuario.pedidos_distribuidor, :proveedor => @usuario.pedidos_proveedor} 
		end
	end

	#GET /usuarios/:usuario_id/pedidos/:id
	def show
		render json: @pedido
	end

	# POST /pedidos
	def create
		@pedido.update(parametros_pedido_crear)
		@pedido.save
		@pedido.update(parametros_pedido_producto_crear)
		if @pedido.save
			render json: @pedido, status: :created
		else
			render json: @pedido.errors, status: :unprocessable_entity
    	end
    end

    # PUT /pedidos/:id
    def update
    	@pedido.update(parametros_actualizar_pedido)
    	if @pedido.save
			head :no_content
		else
			render json: @pedido.errors, status: :unprocessable_entity
    	end
    end

    # DELETE /pedidos/:id
    def destroy
    	if @pedido.destroy
    		head :no_content
    	else
    		render json: @pedido.errors, status: :unprocessable_entity
    	end
    end

private

	def parametros_pedido_crear
    	params.permit(:direccion,
    	:comprobante_pago,
    	:numero_guia,
    	:costo_total,
    	:estado,
    	:distribuidor_id,
    	:proveedor_id)
	end

	def parametros_pedido_producto_crear
		params.permit(pedidos_productos_attributes: [:producto_id, :precio, :cantidad])
	end

	def parametros_actualizar_pedido
		params.permit(:direccion,
    	:comprobante_pago,
    	:numero_guia,
    	:costo_total,
    	:estado,
    	:distribuidor_id,
    	:proveedor_id,
    	pedidos_productos_attributes: [:producto_id, :precio, :cantidad, :_destroy, :id])
    end
end
