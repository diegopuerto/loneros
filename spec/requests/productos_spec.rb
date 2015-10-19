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
			caracteristica_uno = FactoryGirl.create :caracteristica_uno
			caracteristica_dos = FactoryGirl.create :caracteristica_dos
			precio_uno = FactoryGirl.create :precio1
			parametros_precio_uno = FactoryGirl.attributes_for :precio1
			precio_dos = FactoryGirl.create :precio2
			imagen_uno = FactoryGirl.create :imagen_uno
			imagen_dos = FactoryGirl.create :imagen_dos
			categoria_uno = FactoryGirl.create :categoria_uno
			categoria_dos = FactoryGirl.create :categoria_dos

			@producto_uno.caracteristicas << [caracteristica_uno, caracteristica_dos]
			@producto_uno.precios << [precio_uno, precio_dos]
			@producto_uno.imagenes << [imagen_uno, imagen_dos]
			@producto_uno.categorias << [categoria_uno, categoria_dos]

			@usuario_uno.productos << @producto_uno

			get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }

			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			producto = body["producto"]
			expect(producto["nombre"]).to eq @producto_uno.nombre
      		expect(producto["descripcion"]).to eq @producto_uno.descripcion

      		precios = producto["precios"]
			precios_precio = precios.map { |m| m["precio"] }
			cantidades_minimas = precios.map { |m| m["cantidad_minima"]}

			caracteristicas = producto["caracteristicas"]
			nombres_caracteristica = caracteristicas.map { |m| m["nombre"] }
			valores_caracteristica = caracteristicas.map { |m| m["valor"]}

			imagenes = producto["imagenes"]
			public_ids_imagen = imagenes.map { |m| m["public_id"] }

			categorias = producto["categorias"]
			nombres_categoria = categorias.map{|m| m["nombre"]}

      		expect(precios_precio).to match_array([precio_uno.precio, precio_dos.precio ])
      		expect(cantidades_minimas).to match_array([precio_uno.cantidad_minima, precio_dos.cantidad_minima])
      		expect(nombres_caracteristica).to match_array([caracteristica_uno.nombre, caracteristica_dos.nombre ])
      		expect(valores_caracteristica).to match_array([caracteristica_uno.valor, caracteristica_dos.valor])
      		expect(public_ids_imagen).to match_array([imagen_uno.public_id, imagen_dos.public_id])
      		expect(nombres_categoria).to match_array([categoria_uno.nombre, categoria_dos.nombre])
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