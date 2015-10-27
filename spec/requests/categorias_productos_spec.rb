require 'rails_helper'

RSpec.describe "CategoriasProductos", type: :request do

	before :each do
      @cabeceras_peticion = {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
      @usuario_uno = FactoryGirl.create :usuario_uno
      @usuario_dos = FactoryGirl.create :usuario_dos
      @admin = FactoryGirl.create :admin
      @producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
      @producto_dos = FactoryGirl.create(:producto2, usuario_id: @usuario_dos.id)
      @categoria_uno = FactoryGirl.create :categoria_uno
      @categoria_dos = FactoryGirl.create :categoria_dos
  end
  
  # index
  describe "GET /usuarios/:usuario_id/productos/:producto_id/categorias" do
    before :each do
       @producto_uno = FactoryGirl.create :producto1,
                       categorias: [FactoryGirl.create(:categoria_uno),
                                    FactoryGirl.create(:categoria_dos)], usuario_id: @usuario_uno.id
        cat = FactoryGirl.create :categoria
    end

    context "usuario autenticado administrador" do
      it "Devuelve todos las categorias del producto con id :producto_id del usuario con id :usuario_id" do

        @cabeceras_peticion.merge! @admin.create_new_auth_token

        get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/categorias", {}, @cabeceras_peticion

        expect(response.status).to eq 200 # OK

        body = JSON.parse(response.body)
        categorias = body['categorias']

        nombres_categoria = categorias.map { |m| m["nombre"] }

        expect(nombres_categoria).to match_array([@categoria_uno.nombre, @categoria_dos.nombre ])
      end
    end
  end

  # create
  describe "POST /usuarios/:usuario_id/productos/:producto_id/categorias" do
    before :each do
        @parametros_categoria = {
          "categoria_id": @categoria_uno.id
        }.to_json

        expect(@producto_uno.categorias).not_to include(@categoria_uno)
    end


    context "usuario autenticado administrador" do
      it " permite agregar una categoria al producto con id :producto_id del usuario con id :usuario_id" do

        @cabeceras_peticion.merge! @admin.create_new_auth_token

        post "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/categorias", @parametros_categoria, @cabeceras_peticion

        expect(response.status).to eq 201 # Created
        expect(@producto_uno.reload.categorias).to include(@categoria_uno)
      end
    end
  end

  # destroy
  describe "DELETE /productos/:producto_id/categorias/:id" do
    before :each do 
      @producto_uno.categorias << @categoria_uno
      expect(@producto_uno.reload.categorias).to include(@categoria_uno)
    end

     context "usuario autenticado administrador" do 

      it "permite quitar la categoria identificada con :id del producto con id :producto_id del usuario :usuario_id" do

        @cabeceras_peticion.merge! @admin.create_new_auth_token

        delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}/categorias/#{@categoria_uno.id}", {}, @cabeceras_peticion

        expect(response.status).to be 204 # No Content
        expect(@producto_uno.reload.categorias.empty?).to be true
        expect(Categoria.exists?(@categoria_uno.id)).to be true
      end
    end
  end
end
