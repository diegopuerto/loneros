require 'rails_helper'

RSpec.describe "Imagenes", type: :request do

	before :each do
    	@cabeceras_peticion = {
      	"Accept": "application/json",
      	"Content-Type": "application/json"
    	}
   		@producto_uno = FactoryGirl.create :producto1
    	@imagen_uno = FactoryGirl.create :imagen_uno
  end

 # index
  	describe "GET /productos/:producto_id/imagenes" do
    	it "Devuelve todas las imagenes del producto con id :producto_id" do
      		producto_uno = FactoryGirl.create :producto1,
        	imagenes: [FactoryGirl.create(:imagen_uno),
				       FactoryGirl.create(:imagen_dos)]

      		imagen = FactoryGirl.create :imagen

      		get "/productos/#{producto_uno.id}/imagenes", {}, { "Accept" => "application/json" }

      		expect(response.status).to eq 200 # OK

      		body = JSON.parse(response.body)
      		imagenes = body['imagenes']

      		public_ids_imagen = imagenes.map { |m| m["public_id"] }

      		expect(public_ids_imagen).to match_array(["public_id_uno", "public_id_dos" ])
    	end
  	end

  	# create
  	describe "POST /productos/:producto_id/imagenes" do
    	it "Agrega una imagen al producto con id :producto_id" do
      		expect(@producto_uno.imagenes).not_to include(@imagen_uno)

      		parametros_imagen = {
        	"imagen_id": @imagen_uno.id
      		}.to_json

      		post "/productos/#{@producto_uno.id}/imagenes", parametros_imagen, @cabeceras_peticion

      		expect(response.status).to eq 201 # Created
      		expect(@producto_uno.reload.imagenes).to include(@imagen_uno)
    	end
  	end

  	# destroy
  	describe "DELETE /productos/:producto_id/imagenes/:id" do
    	it "Quita la imagen identificada con :id del producto con id :producto_id" do
	    	@producto_uno.imagenes << @imagen_uno

      		expect(@producto_uno.reload.imagenes).to include(@imagen_uno)

      		delete "/productos/#{@producto_uno.id}/imagenes/#{@imagen_uno.id}", {}, { "Accept" => "application/json" }

      		expect(response.status).to be 204 # No Content
      		expect(@producto_uno.reload.imagenes.empty?).to be true
      		expect(Imagen.exists?(@imagen_uno.id)).to be false
    	end
  	end

  	#update
  	describe "PUT /productos/:producto_id/imagenes/:id" do
  		it "Actualiza la imagen identificada con :id del producto con id :producto_id" do
  			@producto_uno.imagenes << @imagen_uno

  			expect(@producto_uno.reload.imagenes).to include(@imagen_uno)

  			parametros_imagen = {
        		"public_id" => "otro_public_id",
      		}.to_json

      		put "/productos/#{@producto_uno.id}/imagenes/#{@imagen_uno.id}", parametros_imagen, @cabeceras_peticion
      		expect(response.status).to be 204 # No Content

      		expect(@producto_uno.reload.imagenes.find(@imagen_uno.id).public_id).to eq "otro_public_id"
  		end
  	end


end
