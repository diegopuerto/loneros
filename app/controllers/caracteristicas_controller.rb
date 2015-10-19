class CaracteristicasController < ApplicationController
  before_action :establecer_producto_caracteristica, only: [:destroy, :update]

	# GET /usuarios/:usuario_id/productos/:producto_id/caracteristicas
  def index
  	@producto = Producto.find(params[:producto_id])
    # Actualizar colección de productos
    @producto.caracteristicas.reload
    render json: @producto.caracteristicas
  end

  # POST /usuarios/:usuario_id/productos/:producto_id/caracteristicas
  def create
	  producto = Producto.find(params[:producto_id])
    caracteristica = producto.caracteristicas.new(parametros_caracteristica)
    if caracteristica.save
      render json: caracteristica, status: :created
    else
      render json: {:errors => {caracteristica: ["No se ha podido agregar caracteristica"]}}, status: :unprocessable_entity
    end
  end

  # DELETE /usuarios/:usuario_id/productos/:producto_id/caracteristicas/:id
  def destroy
    @producto.caracteristicas.destroy(@caracteristica)
    head :no_content
  end

  # PATCH/PUT /usuarios/:usuario_id/productos/:producto_id/caracteristicas/:id
	def update
    @producto.caracteristicas.find(@caracteristica.id).update(parametros_caracteristica)
    head :no_content
  end

private
  def parametros_caracteristica
    params.permit(:nombre,
    :valor)
  end

  def establecer_producto_caracteristica
    @producto = Producto.find(params[:producto_id])
    @caracteristica = Caracteristica.find(params[:id])
  end
end

