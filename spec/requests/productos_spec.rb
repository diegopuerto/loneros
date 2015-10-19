describe "Productos API" do

	before :each do
    	@cabeceras_peticion = {
      		"Accept": "application/json",
      	 	"Content-Type": "application/json"
    	}
    	@usuario_uno = FactoryGirl.create :usuario_uno
   		@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
   		@producto_dos = FactoryGirl.create(:producto2, usuario_id: @usuario_uno.id)
   		
  	end

	# index
	describe "GET /usuarios/:usuario_id/productos" do
		before :each do
			@usuario_uno.productos << [@producto_uno, @producto_dos]
  		end

		it "Devuelve todos los productos del usuario con id :usuario_id" do 
						
			get "/usuarios/#{@usuario_uno.id}/productos", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			productos = body['productos']

			nombres_producto = productos.map { |m| m["nombre"] }
      		descripciones_producto = productos.map { |m| m["descripcion"] }

      		expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
      		expect(descripciones_producto).to match_array([@producto_uno.descripcion, @producto_dos.descripcion])
		end
	end

	# show
	describe "GET /usuarios/:usuario_id/productos/:id" do
		it "Devuelve la informacion del producto con id :id del usuario con id :usuario_id" do
			@usuario_uno.productos << @producto_uno

			get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }

			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			producto = body['producto']
			expect(producto["nombre"]).to eq @producto_uno.nombre
      		expect(producto["descripcion"]).to eq @producto_uno.descripcion
      	end
	end

	# destroy
	describe "DELETE /usuarios/:usuario_id/productos/:id" do
		it "Elimina el producto con id :id del usuario con id :usuario_id" do
			@usuario_uno.productos << @producto_uno
			expect(@usuario_uno.productos).to include @producto_uno

			delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }
			
			expect(response.status).to be 204 # No Content
			expect(@usuario_uno.reload.productos).not_to include @producto_uno
      	end
	end


	# create
	describe "POST /usuarios/:usuario_id/productos" do
		it "Crea un producto al usuario con id :usuario_id" do 

      		parametros_producto = FactoryGirl.attributes_for(:producto1).to_json

      		post "/usuarios/#{@usuario_uno.id}/productos", parametros_producto, @cabeceras_peticion

      		expect(response.status).to eq 201 # Created
      		expect(@usuario_uno.productos).to include @producto_uno
      		expect(@usuario_uno.productos.first.nombre).to eq @producto_uno.nombre
      		expect(@usuario_uno.productos.first.descripcion).to eq @producto_uno.descripcion
      	end
	end

	# update
	describe "PUT /productos/:usuario_id/productos/:id" do
		it "Actualiza el producto con id :id del usuario con id :usuario_id" do

			parametros_producto = FactoryGirl.attributes_for(:producto2).to_json

      		@usuario_uno.productos << @producto_uno

      		put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", parametros_producto, @cabeceras_peticion

      		expect(response.status).to be 204 # No content

      		expect(@usuario_uno.productos.first.nombre).to eq @producto_dos.nombre
      		expect(@usuario_uno.productos.first.descripcion).to eq @producto_dos.descripcion
      	end	
	end

	# index
	describe "GET /productos" do
		it "Devuelve todos los productos" do 
			#producto2 = FactoryGirl.create :producto2

			get "/productos", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			productos = body['productos']

			nombres_producto = productos.map { |m| m["nombre"] }
      		descripciones_producto = productos.map { |m| m["descripcion"] }

      		expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
      		expect(descripciones_producto).to match_array([@producto_uno.descripcion, @producto_dos.descripcion])
		end
	end

	# show
	describe "GET /productos/:id" do
		it "Devuelve la informacion del producto con id :id" do

			get "/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }
			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			producto = body['producto']
			expect(producto["nombre"]).to eq @producto_uno.nombre
      		expect(producto["descripcion"]).to eq @producto_uno.descripcion
      	end
	end
end