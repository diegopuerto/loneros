require 'rails_helper'

RSpec.describe "Categorias", type: :request do
 	
 	before :each do
    @cabeceras_peticion = {
      	"Accept": "application/json",
      	 "Content-Type": "application/json"
    }
   	@categoria_uno = FactoryGirl.create :categoria_uno
   	@usuario_uno = FactoryGirl.create :usuario_uno
   	@admin = FactoryGirl.create :admin
  	end

  # index
	describe "GET /categorias" do
		before :each do
			@categoria_dos = FactoryGirl.create :categoria_dos
		end

		context "usuario autenticado administrador" do
			it "Devuelve todos las categorias" do 

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				get "/categorias", {}, @cabeceras_peticion

				expect(response.status).to eq 200 #OK

				body = JSON.parse(response.body)
				categorias = body['categorias']

				nombres_categoria = categorias.map { |m| m["nombre"] }
 
      			expect(nombres_categoria).to match_array(["categoria_uno", "categoria_dos" ])
			end
		end

    context "usuario autenticado no administrador" do
      it "Devuelve todas las categorias" do
        @cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

        get "/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        categorias = body['categorias']

        nombres_categoria = categorias.map { |m| m["nombre"] }

        expect(nombres_categoria).to match_array([@categoria_uno.nombre, @categoria_dos.nombre])
      end

    end
	end

	# show
	describe "GET /categorias/:id" do
		
		context "usuario autenticado administrador" do
			it "Devuelve la informacion de la categoria con id :id" do

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				get "/categorias/#{@categoria_uno.id}", {}, @cabeceras_peticion
				expect(response.status).to eq 200 #OK
				body = JSON.parse(response.body)
				categoria = body['categoria']
				expect(categoria["nombre"]).to eq "categoria_uno"
      		end
		end
	end

	# destroy
	describe "DELETE /categorias/:id" do
		
		context "usuario autenticado administrador" do
			it "permite eliminar la categoria con id :id" do

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				delete "/categorias/#{@categoria_uno.id}", {}, @cabeceras_peticion
			
				expect(response.status).to be 204 # No Content
      			expect(Categoria.count).to eq 0
      		end
		end
	end

	# create
	describe "POST /categorias" do
		before :each do
			Categoria.delete_all
		end

		context "usuario autenticado administrador" do
			it "permite crear una categoria" do 

      			parametros_categoria = FactoryGirl.attributes_for(:categoria_uno).to_json

      			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			post "/categorias", parametros_categoria, @cabeceras_peticion
      			expect(response.status).to eq 201 # Created
      			expect(Categoria.first.nombre).to eq @categoria_uno.nombre
      		end
		end
	end

	# update
	describe "PUT /categorias/:id" do
		before :each do 
			@categoria_dos = FactoryGirl.create :categoria_dos
			@parametros_categoria = FactoryGirl.attributes_for(:categoria_dos).to_json
		end

		context "usuario autenticado administrador" do 
			it "permite actualizar categoria con id :id" do

      			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			put "/categorias/#{@categoria_uno.id}", @parametros_categoria, @cabeceras_peticion

      			expect(response.status).to be 204 # No content

      			expect(Categoria.first.nombre).to eq @categoria_dos.nombre
      		end	
		end
	end
end
