require 'rails_helper'

RSpec.describe "Imagenes", type: :request do

	before :each do
    	@cabeceras_peticion = {
      	"Accept": "application/json",
      	"Content-Type": "application/json"
    	}
      @usuario_uno = FactoryGirl.create :usuario_uno
   		@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
    	@imagen_uno = FactoryGirl.create :imagen_uno
      @imagen_dos = FactoryGirl.create :imagen_dos
  end

 # index
  	describe "GET /usuarios/:usuario_id/productos/:producto_id/imagenes" do
    	it "Devuelve todas las imagenes del producto con id :producto_id del usuario con id :usuario_id" do
      	producto_uno = FactoryGirl.create :producto1,
        imagenes: [FactoryGirl.create(:imagen_uno),
				           FactoryGirl.create(:imagen_dos)], usuario_id: @usuario_uno.id

      	imagen = FactoryGirl.create :imagen

      	get "/usuarios/#{@usuario_uno.id}/productos/#{producto_uno.id}/imagenes", {}, { "Accept" => "application/json" }

      	expect(response.status).to eq 200 # OK
      	body = JSON.parse(response.body)
      	imagenes = body['imagenes']

      	public_ids_imagen = imagenes.map { |m| m["public_id"] }

      	expect(public_ids_imagen).to match_array([@imagen_uno.public_id, @imagen_dos.public_id ])
    	end
  	end

  	# create
  	describe "POST /usuarios/:usuario_id/productos/:producto_id/imagenes" do
    	it "Agrega una imagen al producto con id :producto_id del usuario con id :usuario_id" do
      	expect(@producto_uno.imagenes).not_to include(@imagen_uno)

      	parametros_imagen = {
        "public_id": @imagen_uno.public_id
      	}.to_json

      	post "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/imagenes", parametros_imagen, @cabeceras_peticion

      	expect(response.status).to eq 201 # Created
      	expect(@producto_uno.reload.imagenes.first.public_id).to eq @imagen_uno.public_id
    	end
  	end

  	# destroy
  	describe "DELETE /usuarios/:usuario_id/productos/:producto_id/imagenes/:id" do
    	it "Quita la imagen con id :id del producto con id :producto_id del usuario con id :usuario_id" do
	    	@producto_uno.imagenes << @imagen_uno

      	expect(@producto_uno.reload.imagenes).to include(@imagen_uno)

      	delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/imagenes/#{@imagen_uno.id}", {}, { "Accept" => "application/json" }

      	expect(response.status).to be 204 # No Content
      	expect(@producto_uno.reload.imagenes.empty?).to be true
      	expect(Imagen.exists?(@imagen_uno.id)).to be false
    	end
  	end

  	#update
  	describe "PUT /usuarios/:usuario_id/productos/:producto_id/imagenes/:id" do
  		it "Actualiza la imagen identificada con :id del producto con id :producto_id del usuario con id :usuario_id" do
  			@producto_uno.imagenes << @imagen_uno

  			expect(@producto_uno.reload.imagenes).to include(@imagen_uno)

        parametros_imagen = FactoryGirl.attributes_for(:imagen_dos).to_json

      	put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/imagenes/#{@imagen_uno.id}", parametros_imagen, @cabeceras_peticion
      	expect(response.status).to be 204 # No Content

      	expect(@producto_uno.reload.imagenes.first.public_id).to eq @imagen_dos.public_id
  		end
  	end
end
