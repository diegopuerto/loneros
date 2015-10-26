describe "Productos API" do

	before :each do
    	@cabeceras_peticion = {
      		"Accept": "application/json",
      	 	"Content-Type": "application/json"
    	}
    	@usuario_uno = FactoryGirl.create :usuario_uno
   		@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
   		@producto_dos = FactoryGirl.create(:producto2, usuario_id: @usuario_uno.id)
   		@categoria_uno = FactoryGirl.create :categoria_uno
   		@categoria_dos = FactoryGirl.create :categoria_dos
   		@admin = FactoryGirl.create :admin
   		@usuario_dos = FactoryGirl.create :usuario_dos
  	end

	# index
	describe "GET /usuarios/:usuario_id/productos" do
		before :each do
			@usuario_uno.productos << [@producto_uno, @producto_dos]
  		end

  		context "usuario no autenticado" do
      		it "permite la consulta de productos del usuario con id :usuario_id" do
        		get "/usuarios/#{@usuario_uno.id}/productos", {}, @cabeceras_peticion

				expect(response.status).to eq 200 #OK

				body = JSON.parse(response.body)
				productos = body['productos']

				nombres_producto = productos.map { |m| m["nombre"] }
      			descripciones_producto = productos.map { |m| m["descripcion"] }

      			expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
      			expect(descripciones_producto).to match_array([@producto_uno.descripcion, @producto_dos.descripcion])
      		end
    	end

    	context "usuario autenticado no administrador" do
      		it "permite la consulta de productos del usuario con id :usuario_id" do

      			@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

        		get "/usuarios/#{@usuario_uno.id}/productos", {}, @cabeceras_peticion

				expect(response.status).to eq 200 #OK

				body = JSON.parse(response.body)
				productos = body['productos']

				nombres_producto = productos.map { |m| m["nombre"] }
      			descripciones_producto = productos.map { |m| m["descripcion"] }

      			expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
      			expect(descripciones_producto).to match_array([@producto_uno.descripcion, @producto_dos.descripcion])
      		end
    	end

    	context "usuario autenticado no administrador" do
			it "Devuelve todos los productos del usuario con id :usuario_id" do 

				@cabeceras_peticion.merge! @admin.create_new_auth_token
						
				get "/usuarios/#{@usuario_uno.id}/productos", {}, @cabeceras_peticion

				expect(response.status).to eq 200 #OK

				body = JSON.parse(response.body)
				productos = body['productos']

				nombres_producto = productos.map { |m| m["nombre"] }
      			descripciones_producto = productos.map { |m| m["descripcion"] }

      			expect(nombres_producto).to match_array([@producto_uno.nombre, @producto_dos.nombre ])
      			expect(descripciones_producto).to match_array([@producto_uno.descripcion, @producto_dos.descripcion])
			end
		end
	end

	# show
	describe "GET /usuarios/:usuario_id/productos/:id" do
		before :each do
			@caracteristica_uno = FactoryGirl.create :caracteristica_uno
			@caracteristica_dos = FactoryGirl.create :caracteristica_dos
			@precio_uno = FactoryGirl.create :precio1
			@parametros_precio_uno = FactoryGirl.attributes_for :precio1
			@precio_dos = FactoryGirl.create :precio2
			@imagen_uno = FactoryGirl.create :imagen_uno
			@imagen_dos = FactoryGirl.create :imagen_dos
			@categoria_uno = FactoryGirl.create :categoria_uno
			@categoria_dos = FactoryGirl.create :categoria_dos

			@producto_uno.caracteristicas << [@caracteristica_uno, @caracteristica_dos]
			@producto_uno.precios << [@precio_uno, @precio_dos]
			@producto_uno.imagenes << [@imagen_uno, @imagen_dos]
			@producto_uno.categorias << [@categoria_uno, @categoria_dos]

			@usuario_uno.productos << @producto_uno
		end

		context "usuario no autenticado" do
			it "Devuelve la informacion del producto con id :id del usuario con id :usuario_id" do

				get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

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

      			expect(precios_precio).to match_array([@precio_uno.precio, @precio_dos.precio ])
      			expect(cantidades_minimas).to match_array([@precio_uno.cantidad_minima, @precio_dos.cantidad_minima])
      			expect(nombres_caracteristica).to match_array([@caracteristica_uno.nombre, @caracteristica_dos.nombre ])
      			expect(valores_caracteristica).to match_array([@caracteristica_uno.valor, @caracteristica_dos.valor])
      			expect(public_ids_imagen).to match_array([@imagen_uno.public_id, @imagen_dos.public_id])
      			expect(nombres_categoria).to match_array([@categoria_uno.nombre, @categoria_dos.nombre])
      		end
		end

		context "usuario autenticado no administrador" do
			it "Devuelve la informacion del producto con id :id del usuario con id :usuario_id" do

				@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

				get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

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

      			expect(precios_precio).to match_array([@precio_uno.precio, @precio_dos.precio ])
      			expect(cantidades_minimas).to match_array([@precio_uno.cantidad_minima, @precio_dos.cantidad_minima])
      			expect(nombres_caracteristica).to match_array([@caracteristica_uno.nombre, @caracteristica_dos.nombre ])
      			expect(valores_caracteristica).to match_array([@caracteristica_uno.valor, @caracteristica_dos.valor])
      			expect(public_ids_imagen).to match_array([@imagen_uno.public_id, @imagen_dos.public_id])
      			expect(nombres_categoria).to match_array([@categoria_uno.nombre, @categoria_dos.nombre])
      		end
		end

		context "usuario autenticado administrador" do
			it "Devuelve la informacion del producto con id :id del usuario con id :usuario_id" do

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				get "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion

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

      			expect(precios_precio).to match_array([@precio_uno.precio, @precio_dos.precio ])
      			expect(cantidades_minimas).to match_array([@precio_uno.cantidad_minima, @precio_dos.cantidad_minima])
      			expect(nombres_caracteristica).to match_array([@caracteristica_uno.nombre, @caracteristica_dos.nombre ])
      			expect(valores_caracteristica).to match_array([@caracteristica_uno.valor, @caracteristica_dos.valor])
      			expect(public_ids_imagen).to match_array([@imagen_uno.public_id, @imagen_dos.public_id])
      			expect(nombres_categoria).to match_array([@categoria_uno.nombre, @categoria_dos.nombre])
      		end
		end
	end

	# destroy
	describe "DELETE /usuarios/:usuario_id/productos/:id" do
		before :each do
			@usuario_uno.productos << @producto_uno
			expect(@usuario_uno.productos).to include @producto_uno
		end

		context "usuario no autenticado" do
			it "no le permite eliminar el producto con id :id del usuario con id :usuario_id" do

				delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion
			
				expect(response.status).to be 401 # Unauthorized
				expect(@usuario_uno.reload.productos).to include @producto_uno
      		end
		end

		context "usuario autenticado no dueño del producto" do
			it "no le permite eliminar el producto con id :id del usuario con id :usuario_id" do

				@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

				delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion
			
				expect(response.status).to be 401 # Unauthorized
				expect(@usuario_uno.reload.productos).to include @producto_uno
      		end
		end

		context "usuario autenticado dueño del producto" do
			it "le permite eliminar el  producto con id :id del usuario con id :usuario_id" do

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

				delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion
			
				expect(response.status).to be 204 # Unauthorized
				expect(@usuario_uno.reload.productos).not_to include @producto_uno
      		end
		end

		context "usuario autenticado administrador" do
			it "le permite eliminar el  producto con id :id del usuario con id :usuario_id" do

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				delete "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", {}, @cabeceras_peticion
			
				expect(response.status).to be 204 # Unauthorized
				expect(@usuario_uno.reload.productos).not_to include @producto_uno
      		end
		end
	end

	# create
	describe "POST /usuarios/:usuario_id/productos" do

		before :each do	

			@producto_tres = FactoryGirl.create(:producto_tres, usuario_id: @usuario_uno.id)
			@precio_uno = FactoryGirl.create :precio1
			@precio_dos = FactoryGirl.create :precio2
			@caracteristica_uno = FactoryGirl.create :caracteristica_uno
			@imagen_uno = FactoryGirl.create :imagen_uno

      		@parametros_producto = {nombre: @producto_tres.nombre, descripcion: @producto_tres.descripcion, 
      			precios_attributes: [{cantidad_minima: @precio_uno.cantidad_minima, precio: @precio_uno.precio}, {cantidad_minima: @precio_dos.cantidad_minima, precio: @precio_dos.precio}], 
      			caracteristicas_attributes: [{nombre: @caracteristica_uno.nombre, valor: @caracteristica_uno.valor}],
      			imagenes_attributes: [{ public_id: @imagen_uno.public_id}], 
      			categorias: [{ nombre: @categoria_uno.nombre}, { nombre: @categoria_dos.nombre}]}.to_json
      	end


		context "usuario no autenticado" do
			it "no le permite crear un producto" do 

      			post "/usuarios/#{@usuario_uno.id}/productos", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to eq 401 # Unauthorized
      		end
		end

		context "usuario autenticado" do
			it "le permite crear un producto" do 

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

      			post "/usuarios/#{@usuario_uno.id}/productos", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to eq 201 # Created
      			expect(@usuario_uno.productos.last.nombre).to eq @producto_tres.nombre
      			expect(@usuario_uno.productos.last.descripcion).to eq @producto_tres.descripcion
      			expect(@usuario_uno.productos.last.precios.first.precio).to eq @precio_uno.precio
      			expect(@usuario_uno.productos.last.precios.first.cantidad_minima).to eq @precio_uno.cantidad_minima
      			expect(@usuario_uno.productos.last.precios.last.precio).to eq @precio_dos.precio
      			expect(@usuario_uno.productos.last.precios.last.cantidad_minima).to eq @precio_dos.cantidad_minima
      	    	expect(@usuario_uno.productos.last.caracteristicas.first.nombre).to eq @caracteristica_uno.nombre
      			expect(@usuario_uno.productos.last.caracteristicas.first.valor).to eq @caracteristica_uno.valor
      			expect(@usuario_uno.productos.last.imagenes.first.public_id).to eq @imagen_uno.public_id
      			expect(@usuario_uno.productos.last.categorias).to match_array [@categoria_uno, @categoria_dos]
      		end
		end

		context "usuario autenticado administrador" do
			it "le permite crear un producto" do 

				@cabeceras_peticion.merge! @admin.create_new_auth_token

      			post "/usuarios/#{@usuario_uno.id}/productos", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to eq 201 # Created
      			expect(@usuario_uno.productos.last.nombre).to eq @producto_tres.nombre
      			expect(@usuario_uno.productos.last.descripcion).to eq @producto_tres.descripcion
      			expect(@usuario_uno.productos.last.precios.first.precio).to eq @precio_uno.precio
      			expect(@usuario_uno.productos.last.precios.first.cantidad_minima).to eq @precio_uno.cantidad_minima
      			expect(@usuario_uno.productos.last.precios.last.precio).to eq @precio_dos.precio
      			expect(@usuario_uno.productos.last.precios.last.cantidad_minima).to eq @precio_dos.cantidad_minima
      	    	expect(@usuario_uno.productos.last.caracteristicas.first.nombre).to eq @caracteristica_uno.nombre
      			expect(@usuario_uno.productos.last.caracteristicas.first.valor).to eq @caracteristica_uno.valor
      			expect(@usuario_uno.productos.last.imagenes.first.public_id).to eq @imagen_uno.public_id
      			expect(@usuario_uno.productos.last.categorias).to match_array [@categoria_uno, @categoria_dos]
      		end
		end
	end

	# update
	describe "PUT /productos/:usuario_id/productos/:id" do
		
		before :each do
			@caracteristica_uno = FactoryGirl.create :caracteristica_uno
			@caracteristica_dos = FactoryGirl.create :caracteristica_dos
			@caracteristica_tres = FactoryGirl.create :caracteristica_tres
			@caracteristica_cuatro = FactoryGirl.create :caracteristica_cuatro
			@precio_uno = FactoryGirl.create :precio1
			@precio_dos = FactoryGirl.create :precio2
			@imagen_uno = FactoryGirl.create :imagen_uno
			@imagen_dos = FactoryGirl.create :imagen_dos
			@imagen_tres = FactoryGirl.create :imagen_tres

			@producto_uno.caracteristicas << [@caracteristica_uno, @caracteristica_dos]
			@producto_uno.precios << [@precio_uno, @precio_dos]
			@producto_uno.imagenes << [@imagen_uno, @imagen_dos]
			@producto_uno.categorias << @categoria_uno

			@parametros_producto = {nombre: @producto_dos.nombre, descripcion: @producto_dos.descripcion, 
      			precios_attributes: [{id: @precio_uno.id, cantidad_minima: 20, precio: 50000}, {id: @precio_dos.id, _destroy: 1}], 
      			caracteristicas_attributes: [{ id: 1, nombre: @caracteristica_tres.nombre, valor: @caracteristica_tres.valor}, { nombre: @caracteristica_cuatro.nombre, valor: @caracteristica_cuatro.valor}],
      			imagenes_attributes: [{ id: 2, public_id: @imagen_tres.public_id}], categorias: [{ nombre: @categoria_dos.nombre }]}.to_json
      	end

      	context "usuario no autenticado" do
      		it "Actualiza el producto con id :id del usuario con id :usuario_id" do

      			put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to be 401 #Unauthorized
      		end	
		end

		context "usuario autenticado no administrador" do
      		it "Actualiza el producto con id :id del usuario con id :usuario_id" do

      			@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

      			put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to be 204 # No Content

      			expect(Producto.find(@producto_uno.id).nombre).to eq @producto_dos.nombre
      			expect(Producto.find(@producto_uno.id).descripcion).to eq @producto_dos.descripcion
      			expect(Producto.find(@producto_uno.id).precios.count).to eq 1
      			expect(Precio.find(@precio_uno.id).cantidad_minima).to eq 20
      			expect(Precio.find(@precio_uno.id).precio).to  eq 50000
      			expect(Caracteristica.find(@caracteristica_uno.id).nombre).to eq @caracteristica_tres.nombre
      			expect(Caracteristica.find(@caracteristica_uno.id).valor).to eq @caracteristica_tres.valor
      			expect(Producto.find(@producto_uno.id).caracteristicas.count).to eq 3
      			expect(Imagen.find(@imagen_dos.id).public_id).to eq @imagen_tres.public_id
      			expect(Producto.find(@producto_uno.id).categorias.count).to eq 1
      			expect(Producto.find(@producto_uno.id).categorias[0].nombre).to eq @categoria_dos.nombre
      			

      		end	
		end

		context "usuario autenticado administrador" do
      		it "Actualiza el producto con id :id del usuario con id :usuario_id" do

      			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			put "/usuarios/#{@usuario_uno.id}/productos/#{@producto_uno.id}", @parametros_producto, @cabeceras_peticion

      			expect(response.status).to be 204 #No Content

      			expect(Producto.find(@producto_uno.id).nombre).to eq @producto_dos.nombre
      			expect(Producto.find(@producto_uno.id).descripcion).to eq @producto_dos.descripcion
      			expect(Producto.find(@producto_uno.id).precios.count).to eq 1
      			expect(Precio.find(@precio_uno.id).cantidad_minima).to eq 20
      			expect(Precio.find(@precio_uno.id).precio).to  eq 50000
      			expect(Caracteristica.find(@caracteristica_uno.id).nombre).to eq @caracteristica_tres.nombre
      			expect(Caracteristica.find(@caracteristica_uno.id).valor).to eq @caracteristica_tres.valor
      			expect(Producto.find(@producto_uno.id).caracteristicas.count).to eq 3
      			expect(Imagen.find(@imagen_dos.id).public_id).to eq @imagen_tres.public_id
      			expect(Producto.find(@producto_uno.id).categorias.count).to eq 1
      			expect(Producto.find(@producto_uno.id).categorias[0].nombre).to eq @categoria_dos.nombre
      		end	
		end
	end

	# index
	describe "GET /productos" do
		context "usuario no autenticado" do 
			it "Devuelve todos los productos" do 

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

		context "usuario autenticado no administrador" do 
			it "Devuelve todos los productos" do 

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

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

		context "usuario autenticado administrador" do 
			it "Devuelve todos los productos" do 

				@cabeceras_peticion.merge! @admin.create_new_auth_token

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
	end

	# show
	describe "GET /productos/:id" do
		context "usuario no autenticado" do
			it "Devuelve la informacion del producto con id :id" do

				get "/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }
				expect(response.status).to eq 200 #OK
				body = JSON.parse(response.body)
				producto = body['producto']
				expect(producto["nombre"]).to eq @producto_uno.nombre
      			expect(producto["descripcion"]).to eq @producto_uno.descripcion
      		end
      	end

      	context "usuario autenticado no administrador" do
			it "Devuelve la informacion del producto con id :id" do

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

				get "/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }
				expect(response.status).to eq 200 #OK
				body = JSON.parse(response.body)
				producto = body['producto']
				expect(producto["nombre"]).to eq @producto_uno.nombre
      			expect(producto["descripcion"]).to eq @producto_uno.descripcion
      		end
      	end

      	context "usuario autenticado administrador" do
			it "Devuelve la informacion del producto con id :id" do

				@cabeceras_peticion.merge! @admin.create_new_auth_token

				get "/productos/#{@producto_uno.id}", {}, { "Accept" => "application/json" }
				expect(response.status).to eq 200 #OK
				body = JSON.parse(response.body)
				producto = body['producto']
				expect(producto["nombre"]).to eq @producto_uno.nombre
      			expect(producto["descripcion"]).to eq @producto_uno.descripcion
      		end
      	end
	end
end