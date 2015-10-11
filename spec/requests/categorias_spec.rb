require 'rails_helper'

RSpec.describe "Categorias", type: :request do
 	
 	before :each do
    @cabeceras_peticion = {
      	"Accept": "application/json",
      	 "Content-Type": "application/json"
    }
   	@categoria_uno = FactoryGirl.create :categoria_uno

  	end

  # index
	describe "GET /categorias" do
		it "Devuelve todos las categorias" do 

			@categoria_dos = FactoryGirl.create :categoria_dos

			get "/categorias", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			categorias = body['categorias']

			nombres_categoria = categorias.map { |m| m["nombre"] }
 
      		expect(nombres_categoria).to match_array(["categoria_uno", "categoria_dos" ])

		end
	end

	# show
	describe "GET /categorias/:id" do
		it "Devuelve la informacion de la categoria con id :id" do

			get "/categorias/#{@categoria_uno.id}", {}, { "Accept" => "application/json" }
			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			categoria = body['categoria']
			expect(categoria["nombre"]).to eq "categoria_uno"
      	end
	end

	# destroy
	describe "DELETE /categorias/:id" do
		it "Elimina la categoria con id :id" do

			delete "/categorias/#{@categoria_uno.id}", {}, {"Accept" => "application/json"}
			
			expect(response.status).to be 204 # No Content
      		expect(Categoria.count).to eq 0
      	end
	end

	# create
	describe "POST /categorias" do
		it "Crea una categoria" do 

      		parametros_categoria = FactoryGirl.attributes_for(:categoria_uno).to_json

      		post "/categorias", parametros_categoria, @cabeceras_peticion
      		expect(response.status).to eq 201 # Created
      		expect(Categoria.first.nombre).to eq @categoria_uno.nombre
      	end
	end

	# update
	describe "PUT /categorias/:id" do
		it "Actualiza la categoria con id :id" do

			parametros_categoria = {
        	"nombre" => "otro_nombre",
      		}.to_json

      		put "/categorias/#{@categoria_uno.id}", parametros_categoria, @cabeceras_peticion

      		expect(response.status).to be 204 # No content

      		expect(Categoria.first.nombre).to eq "otro_nombre"
      	end	
	end
end
