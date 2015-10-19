require 'rails_helper'

RSpec.describe "Precios", type: :request do

  before :each do
    @cabeceras_peticion = {
      	"Accept": "application/json",
      	 "Content-Type": "application/json"
    }
    @usuario_uno = FactoryGirl.create :usuario_uno
   	@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
    @precio_uno = FactoryGirl.create :precio1
    @precio_dos = FactoryGirl.create :precio2
  end
  
	# index
  	describe "GET /usuarios/:usuario_id/productos/:producto_id/precios" do
    	it "Devuelve todos los precios del producto con id :producto_id del usuario con id :usuario_id" do
      	producto_uno = FactoryGirl.create :producto1,
        precios: [FactoryGirl.create(:precio1),
				          FactoryGirl.create(:precio2)], usuario_id: @usuario_uno.id

      	get "/usuarios/#{@usuario_uno.id}/productos/#{producto_uno.id}/precios", {}, { "Accept" => "application/json" }

      	expect(response.status).to eq 200 # OK

      	body = JSON.parse(response.body)
      	precios = body['precios']

      	precios_precio = precios.map { |m| m["precio"] }
      	cantidades_minimas_precio = precios.map { |m| m["cantidad_minima"] }

      	expect(precios_precio).to match_array([@precio_uno.precio, @precio_dos.precio])
      	expect(cantidades_minimas_precio).to match_array([@precio_uno.cantidad_minima, @precio_dos.cantidad_minima])
    end
  end

	# create
  	describe "POST /usuarios/:usuario_id/productos/:producto_id/precios" do
    	it "Agrega un precio al producto con id :producto_id del usuario con id :usuario_id" do
      	expect(@producto_uno.precios).not_to include(@precio_uno)

      	parametros_precio = {
        "precio": @precio_uno.precio,
        "cantidad_minima": @precio_uno.cantidad_minima
      	}.to_json

      	post "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/precios", parametros_precio, @cabeceras_peticion

      	expect(response.status).to eq 201 # Created
      	expect(@producto_uno.reload.precios.first.precio).to eq @precio_uno.precio
        expect(@producto_uno.reload.precios.first.cantidad_minima).to eq @precio_uno.cantidad_minima
    	end
  	end

	# destroy
  	describe "DELETE /usuarios/:usuario_id/productos/:producto_id/precios/:id" do
    	it "Quita el precio identificado con id :id del producto con id :producto_id del usuario con id :usuario_id" do
	    	@producto_uno.precios << @precio_uno

      	expect(@producto_uno.reload.precios).to include(@precio_uno)

      	delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/precios/#{@precio_uno.id}", {}, { "Accept" => "application/json" }

      	expect(response.status).to be 204 # No Content
      	expect(@producto_uno.reload.precios.empty?).to be true
      	expect(Precio.exists?(@precio_uno.id)).to be false
    	end
  	end

  	#update
  	describe "PUT /usuarios/:usuario_id/productos/:producto_id/precios/:id" do
  		it "Actualiza el precio identificado con id :id del producto con id :producto_id del usuario con id :usuario_id" do
  			@producto_uno.precios << @precio_uno

  			expect(@producto_uno.reload.precios).to include(@precio_uno)

        parametros_precio = FactoryGirl.attributes_for(:precio2).to_json

      	put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/precios/#{@precio_uno.id}", parametros_precio, @cabeceras_peticion
      	expect(response.status).to be 204 # No Content

      	expect(@producto_uno.reload.precios.first.precio).to eq @precio_dos.precio
      	expect(@producto_uno.reload.precios.first.cantidad_minima).to eq @precio_dos.cantidad_minima
  		end
  	end
end



