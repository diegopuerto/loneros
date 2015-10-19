require 'rails_helper'

RSpec.describe "Caracteristicas", type: :request do

	before :each do
    	@cabeceras_peticion = {
      	"Accept": "application/json",
      	"Content-Type": "application/json"
    	}
      @usuario_uno = FactoryGirl.create :usuario_uno
   		@producto_uno = FactoryGirl.create :producto1, usuario_id: @usuario_uno.id
    	@caracteristica_uno = FactoryGirl.create :caracteristica_uno
      @caracteristica_dos = FactoryGirl.create :caracteristica_dos
  end
  
  # index
  	describe "GET /productos/:producto_id/caracteristicas" do
    	it "Devuelve todos las caracteristicas del producto con id :producto_id" do
      	producto1 = FactoryGirl.create :producto1,
        caracteristicas: [FactoryGirl.create(:caracteristica_uno),
				            		  FactoryGirl.create(:caracteristica_dos)], usuario_id: @usuario_uno.id

      	caracteristica = FactoryGirl.create :caracteristica

      	get "/usuarios/#{@usuario_uno.id}/productos/#{producto1.id}/caracteristicas", {}, { "Accept" => "application/json" }

      	expect(response.status).to eq 200 # OK

      	body = JSON.parse(response.body)
      	caracteristicas = body['caracteristicas']

      	nombres_caracteristica = caracteristicas.map { |m| m["nombre"] }
      	valores_caracteristicas = caracteristicas.map { |m| m["valor"] }

      	expect(nombres_caracteristica).to match_array(["caracteristica_uno", "caracteristica_dos" ])
      	expect(valores_caracteristicas).to match_array(["valor_uno", "valor_dos"])
    	end
  	end

  	# create
  	describe "POST /productos/:producto_id/caracteristicas" do
    	it "Agrega una caracteristica al producto con id :producto_id" do
      	expect(@producto_uno.caracteristicas).not_to include(@caracteristica_uno)

      	parametros_caracteristica = {
        "nombre": @caracteristica_uno.nombre,
        "valor": @caracteristica_uno.valor
      	}.to_json

      	post "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/caracteristicas", parametros_caracteristica, @cabeceras_peticion

      	expect(response.status).to eq 201 # Created
        expect(@producto_uno.reload.caracteristicas.first.nombre).to eq @caracteristica_uno.nombre
        expect(@producto_uno.reload.caracteristicas.first.valor).to eq @caracteristica_uno.valor
    	end
  	end

  	# destroy
  	describe "DELETE /productos/:producto_id/caracteristicas/:id" do
    	it "Quita la caracteristica identificada con :id del producto con id :producto_id" do
	    	@producto_uno.caracteristicas << @caracteristica_uno

      	expect(@producto_uno.reload.caracteristicas).to include(@caracteristica_uno)

      	delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/caracteristicas/#{@caracteristica_uno.id}", {}, { "Accept" => "application/json" }

      	expect(response.status).to be 204 # No Content
      	expect(@producto_uno.reload.caracteristicas.empty?).to be true
      	expect(Caracteristica.exists?(@caracteristica_uno.id)).to be false
    	end
  	end

  	#update
  	describe "PUT /productos/:producto_id/caracteristicas/:id" do
  		it "Actualiza la caracteristica identificada con :id del producto con id :producto_id" do
  			@producto_uno.caracteristicas << @caracteristica_uno

  			expect(@producto_uno.reload.caracteristicas).to include(@caracteristica_uno)

        parametros_caracteristica = FactoryGirl.attributes_for(:caracteristica_dos).to_json

      	put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/caracteristicas/#{@caracteristica_uno.id}", parametros_caracteristica, @cabeceras_peticion
      	expect(response.status).to be 204 # No Content

      	expect(@producto_uno.reload.caracteristicas.find(@caracteristica_uno.id).nombre).to eq @caracteristica_dos.nombre
      	expect(@producto_uno.reload.caracteristicas.find(@caracteristica_uno.id).valor).to eq @caracteristica_dos.valor
  		end
  	end
end
