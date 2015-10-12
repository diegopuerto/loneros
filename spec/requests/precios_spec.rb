require 'rails_helper'

RSpec.describe "Precios", type: :request do

  before :each do
    @cabeceras_peticion = {
      	"Accept": "application/json",
      	 "Content-Type": "application/json"
    }
   	@producto_uno = FactoryGirl.create :producto1
    @precio_uno = FactoryGirl.create :precio1
  end
  
	# index
  	describe "GET /productos/:producto_id/precios" do
    	it "Devuelve todos los precios del producto con id :producto_id" do
      		producto1 = FactoryGirl.create :producto1,
        	precios: [FactoryGirl.create(:precio1),
				      FactoryGirl.create(:precio2)]

      		price = FactoryGirl.create :precio

      		get "/productos/#{producto1.id}/precios", {}, { "Accept" => "application/json" }

      		expect(response.status).to eq 200 # OK

      		body = JSON.parse(response.body)
      		precios = body['precios']

      		precios_precio = precios.map { |m| m["precio"] }
      		cantidades_minimas_precio = precios.map { |m| m["cantidad_minima"] }

      		expect(precios_precio).to match_array([1000, 2000 ])
      		expect(cantidades_minimas_precio).to match_array([4, 10])
    end
  end

	# create
  	describe "POST /productos/:producto_id/precios" do
    	it "Agrega un precio al producto con id :producto_id" do
      		expect(@producto_uno.precios).not_to include(@precio_uno)

      		parametros_precio = {
        	"precio_id": @precio_uno.id
      		}.to_json

      		post "/productos/#{@producto_uno.id}/precios", parametros_precio, @cabeceras_peticion

      		expect(response.status).to eq 201 # Created
      		expect(@producto_uno.reload.precios).to include(@precio_uno)
    	end
  	end

	# destroy
  	describe "DELETE /productos/:producto_id/precios/:id" do
    	it "Quita el precio identificado con :id del producto con id :producto_id" do
	    	@producto_uno.precios << @precio_uno

      		expect(@producto_uno.reload.precios).to include(@precio_uno)

      		delete "/productos/#{@producto_uno.id}/precios/#{@precio_uno.id}", {}, { "Accept" => "application/json" }

      		expect(response.status).to be 204 # No Content
      		expect(@producto_uno.reload.precios.empty?).to be true
      		expect(Precio.exists?(@precio_uno.id)).to be false
    	end
  	end

  	#update
  	describe "PUT /productos/:producto_id/precios/:id" do
  		it "Actualiza el precio identificado con :id del producto con id :producto_id" do
  			@producto_uno.precios << @precio_uno

  			expect(@producto_uno.reload.precios).to include(@precio_uno)

  			parametros_precio = {
        		"precio" => 35000,
        		"cantidad_minima" => 20,
      		}.to_json

      		put "/productos/#{@producto_uno.id}/precios/#{@precio_uno.id}", parametros_precio, @cabeceras_peticion
      		expect(response.status).to be 204 # No Content

      		expect(@producto_uno.reload.precios.find(@precio_uno.id).precio).to eq 35000
      		expect(@producto_uno.reload.precios.find(@precio_uno.id).cantidad_minima).to eq 20
  		end
  	end

end



