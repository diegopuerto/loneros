class CategoriasController < ApplicationController
	before_action :establecer_categoria, only: [:show, :destroy, :update]

  # GET /usuarios/:usuario_id/productos/:producto_id/categorias
  # GET /categorias
  def index
    if params[:categoria_producto]
      render json: Producto.find(params[:producto_id]).categorias
    else
      @categorias = Categoria.all
      render json: @categorias
    end
  end

  # GET /categorias/1
  def show
    render json: @categoria
  end

  # DELETE /usuarios/:usuario_id/productos/:producto_id/categorias/:id
  # DELETE /categorias/:id
  def destroy
    if params[:categoria_producto]
      @producto = Producto.find(params[:producto_id])
      @producto.categorias.destroy(@categoria)
      head :no_content
    else
  	  @categoria.destroy
      head :no_content
    end
  end

  # POST /usuarios/:usuario_id/productos/:producto_id/categorias
  # POST /categorias
  def create
    if params[:categoria_producto]
      p = Producto.find(params[:producto_id])
      c = Categoria.find(params[:categoria_id])

      if p.categorias << c
        render json: c, status: :created
      else
        render json: {:errors => {categoria: ["No se ha podido agregar categoria"]}}, status: :unprocessable_entity
      end
    else
      @categoria = Categoria.new(parametros_categoria)
  	  if @categoria.save
        render json: @categoria, status: :created
      else
        render json: @categoria.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /categorias/1
  def update
    if @categoria.update(parametros_categoria)
		  head :no_content
    else
      render json: @categoria.errors, status: :unprocessable_entity
    end
  end

private
	def establecer_categoria
  	@categoria = Categoria.find(params[:id])
	end

	def parametros_categoria
    params.permit(:nombre)
  end
end
