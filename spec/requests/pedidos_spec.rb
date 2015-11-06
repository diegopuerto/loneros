require 'rails_helper'

RSpec.describe "Pedidos", type: :request do

	before :each do
		@cabeceras_peticion = {
      		"Accept": "application/json",
      	 	"Content-Type": "application/json"
    	}
 
 	end

	# index
	describe "GET /pedidos" do
		before :each do 
			@pedido_uno = FactoryGirl.create :pedido_uno
			@pedido_dos = FactoryGirl.create :pedido_dos
			@pedido_tres = FactoryGirl.create :pedido_tres
			@usuario_uno = FactoryGirl.create :usuario_uno
			@usuario_dos = FactoryGirl.create :usuario_dos
			@admin = FactoryGirl.create :admin
			@usuario_uno.pedidos_distribuidor << @pedido_uno
            @usuario_uno.pedidos_proveedor << @pedido_dos
            @usuario_dos.pedidos_distribuidor << @pedido_tres
        end

		context "usuario no autenticado" do
			it "no permite la visualizacion de pedidos" do

				get "/pedidos", {}, @cabeceras_peticion

				expect(response.status).to eq 401 # Unauthorized
			end
		end

		context "usuario autenticado no administrador dueño de los pedidos" do 
			it "permite la visualizacion de los pedidos" do 

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

				get "/pedidos", {}, @cabeceras_peticion

				expect(response.status).to eq 200 # OK

				body = JSON.parse(response.body)
                distribuidores = body["distribuidor"]
                proveedores = body["proveedor"]

                direcciones_distribuidores = distribuidores.map { |m| m["direccion"] }
                comprobantes_distribuidores = distribuidores.map { |m| m["comprobante_pago"] }
                guias_distribuidores = distribuidores.map { |m| m["numero_guia"] }
                costos_distribuidores = distribuidores.map { |m| m["costo_total"] }
                estados_distribuidores = distribuidores.map { |m| m["estado"] }

                direcciones_proveedores = proveedores.map { |m| m["direccion"] }
                comprobantes_proveedores = proveedores.map { |m| m["comprobante_pago"] }
                guias_proveedores = proveedores.map { |m| m["numero_guia"] }
                costos_proveedores = proveedores.map { |m| m["costo_total"] }
                estados_proveedores = proveedores.map { |m| m["estado"] }

                expect(direcciones_distribuidores).to match_array([@pedido_uno.direccion])
                expect(comprobantes_distribuidores).to match_array([@pedido_uno.comprobante_pago])
                expect(guias_distribuidores).to match_array([@pedido_uno.numero_guia])
                expect(costos_distribuidores).to match_array([@pedido_uno.costo_total])
                expect(estados_distribuidores).to match_array([@pedido_uno.estado])

                expect(direcciones_proveedores).to match_array([@pedido_dos.direccion])
                expect(comprobantes_proveedores).to match_array([@pedido_dos.comprobante_pago])
                expect(guias_proveedores).to match_array([@pedido_dos.numero_guia])
                expect(costos_proveedores).to match_array([@pedido_dos.costo_total])
                expect(estados_proveedores).to match_array([@pedido_dos.estado])
            end
        end

        context "usuario autenticado administrador" do
        	it "permite la visualizacion de los pedidos" do 

        		@cabeceras_peticion.merge! @admin.create_new_auth_token

				get "/pedidos", {}, @cabeceras_peticion

				expect(response.status).to eq 200 # OK

				body = JSON.parse(response.body)
				pedidos = body["pedidos"]
  
                direcciones_pedidos = pedidos.map { |m| m["direccion"] }
                comprobantes_pedidos = pedidos.map { |m| m["comprobante_pago"] }
                guias_pedidos = pedidos.map { |m| m["numero_guia"] }
                costos_pedidos = pedidos.map { |m| m["costo_total"] }
                estados_pedidos = pedidos.map { |m| m["estado"] }

                expect(direcciones_pedidos).to match_array([@pedido_uno.direccion, @pedido_dos.direccion, @pedido_tres.direccion])
                expect(comprobantes_pedidos).to match_array([@pedido_uno.comprobante_pago, @pedido_dos.comprobante_pago, @pedido_tres.comprobante_pago])
                expect(guias_pedidos).to match_array([@pedido_uno.numero_guia, @pedido_dos.numero_guia, @pedido_tres.numero_guia])
                expect(costos_pedidos).to match_array([@pedido_uno.costo_total, @pedido_dos.costo_total, @pedido_tres.costo_total])
                expect(estados_pedidos).to match_array([@pedido_uno.estado, @pedido_dos.estado, @pedido_tres.estado])
            end
        end
    end

	# show
	describe "GET /usuarios/:usuario_id/pedidos/:id" do
		before :each do 
			@pedido_uno = FactoryGirl.create :pedido_uno
			@usuario_uno = FactoryGirl.create :usuario_uno
			@usuario_dos = FactoryGirl.create :usuario_dos
			@admin = FactoryGirl.create :admin
			@usuario_uno.pedidos_distribuidor << @pedido_uno
		end

		context "usuario no autenticado" do 
			it "no le permite visualizar el pedido identificado con id :id" do 

				get "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

				expect(response.status).to eq 401 # Unauthorized
			end
		end

		context "usuario autenticado no dueño de los pedidos" do 
			it "no le permite visualizar el pedido identificaco con id :id" do

				@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

				get "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

				expect(response.status).to eq 401 # Unauthorized
			end
		end

		context "usuario autenticado dueño de los pedidos" do 
			it "le permite visualizar el pedido identificado con id :id" do 

				@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

				get "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

				expect(response.status).to eq 200 # OK

				body = JSON.parse(response.body)

				pedido = body["pedido"]
				direccion_pedido = pedido["direccion"]
				comprobante_pedido = pedido["comprobante_pago"]
				guia_pedido = pedido["numero_guia"]
				costo_pedido = pedido["costo_total"]
				estado_pedido = pedido["estado"]

				expect(direccion_pedido).to eq @pedido_uno.direccion.to_s
				expect(comprobante_pedido).to eq @pedido_uno.comprobante_pago
				expect(guia_pedido).to eq @pedido_uno.numero_guia
				expect(costo_pedido).to eq @pedido_uno.costo_total
				expect(estado_pedido).to eq @pedido_uno.estado	
			end
		end

		context "usuario autenticado administrador" do 
			it "le permite visualizar el pedido identificado con id :id" do 

				@cabeceras_peticion.merge! @admin.create_new_auth_token


				get "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

				expect(response.status).to eq 200 # OK

				body = JSON.parse(response.body)

				pedido = body["pedido"]
				direccion_pedido = pedido["direccion"]
				comprobante_pedido = pedido["comprobante_pago"]
				guia_pedido = pedido["numero_guia"]
				costo_pedido = pedido["costo_total"]
				estado_pedido = pedido["estado"]

				expect(direccion_pedido).to eq @pedido_uno.direccion.to_s
				expect(comprobante_pedido).to eq @pedido_uno.comprobante_pago
				expect(guia_pedido).to eq @pedido_uno.numero_guia
				expect(costo_pedido).to eq @pedido_uno.costo_total
				expect(estado_pedido).to eq @pedido_uno.estado	
			end
		end
	end

	# create
	describe "POST /pedidos" do
		before :each do 
			@usuario_uno = FactoryGirl.create :usuario_uno
			@usuario_dos = FactoryGirl.create :usuario_dos
			@admin = FactoryGirl.create :admin
			@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
			@producto_dos = FactoryGirl.create(:producto2, usuario_id: @usuario_uno.id)
			@producto_tres = FactoryGirl.create(:producto_tres, usuario_id: @usuario_uno.id)
			@parametros_pedido = {direccion: "Carrera 10a #121-10 apt 101", comprobante_pago: "public_id", numero_guia: "1234567", costo_total: 54000, estado: "nuevo", proveedor_id: @usuario_uno.id, distribuidor_id: @usuario_dos.id, 
      							  pedidos_productos_attributes: [{producto_id: @producto_uno.id, precio: 4000, cantidad: 10}, {producto_id: @producto_dos.id, precio: 9000, cantidad: 15}, {producto_id: @producto_tres.id, precio: 20000, cantidad: 20}]}.to_json
      	end

      	context "usuario no autenticado" do 
      		it "no le permite crear un pedido" do 

      			post "/pedidos", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 401 # Unauthorized
      		end
      	end    	

      	context "usuario autenticado distribuidor/proveedor" do 
      		it "le permite crear pedido" do 

      			@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

      			post "/pedidos", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 201 # Created
      			expect(Pedido.first.productos.count).to eq 3
      			expect(Pedido.first.direccion).to eq "Carrera 10a #121-10 apt 101"
      			expect(Pedido.first.comprobante_pago).to eq "public_id"
      			expect(Pedido.first.numero_guia).to eq "1234567"
      			expect(Pedido.first.costo_total).to eq 54000
      			expect(Pedido.first.estado).to eq "nuevo"
      			expect(Pedido.first.proveedor_id).to eq @usuario_uno.id
      			expect(Pedido.first.distribuidor_id).to eq @usuario_dos.id
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_uno.id).precio).to eq 4000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_uno.id).cantidad).to eq 10
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).precio).to eq 9000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).cantidad).to eq 15
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).precio).to eq 20000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).cantidad).to eq 20
      		end
    	end

    	context "usuario autenticado administrador" do
    		it "le permite crear pedido" do 

    			@cabeceras_peticion.merge! @admin.create_new_auth_token

      			post "/pedidos", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 201 # Created
      			expect(Pedido.first.productos.count).to eq 3
      			expect(Pedido.first.direccion).to eq "Carrera 10a #121-10 apt 101"
      			expect(Pedido.first.comprobante_pago).to eq "public_id"
      			expect(Pedido.first.numero_guia).to eq "1234567"
      			expect(Pedido.first.costo_total).to eq 54000
      			expect(Pedido.first.estado).to eq "nuevo"
      			expect(Pedido.first.proveedor_id).to eq @usuario_uno.id
      			expect(Pedido.first.distribuidor_id).to eq @usuario_dos.id
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_uno.id).precio).to eq 4000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_uno.id).cantidad).to eq 10
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).precio).to eq 9000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).cantidad).to eq 15
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).precio).to eq 20000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).cantidad).to eq 20
      		end
    	end
    end

    # update
    describe "PUT /pedidos/:id" do
    	before :each do 
    		@usuario_uno = FactoryGirl.create :usuario_uno
    		@usuario_dos = FactoryGirl.create :usuario_dos
    		@admin = FactoryGirl.create :admin
			@pedido_uno = FactoryGirl.create :pedido_uno
			@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
			@producto_dos = FactoryGirl.create(:producto2, usuario_id: @usuario_uno.id)
			@producto_tres = FactoryGirl.create(:producto_tres, usuario_id: @usuario_uno.id)
			@pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => 15000)
			@pp = PedidoProducto.find_by(pedido_id: @pedido_uno.id, producto_id: @producto_uno.id)
			@usuario_uno.pedidos_distribuidor << @pedido_uno

			@parametros_pedido = {direccion: "Carrera 10a #121-10 apt 101", comprobante_pago: "public_id", numero_guia: "1234567", costo_total: 54000, estado: "nuevo", proveedor_id: @usuario_uno.id, distribuidor_id: @usuario_dos.id, 
      							  pedidos_productos_attributes: [{producto_id: @producto_uno.id, precio: 4000, cantidad: 10, _destroy: 1, id: @pp.id}, {producto_id: @producto_dos.id, precio: 9000, cantidad: 15}, {producto_id: @producto_tres.id, precio: 20000, cantidad: 20}]}.to_json
      	end

      	context "usuario no autenticado" do 
      		it "no le permite actualizar el producto" do 

      			put "/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 401 # Unauthorized

      		end
      	end

      	context "usuario autenticado no dueño de los productos" do 
      		it "no le permite modificar el producto con id :id" do 

      			@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

      			put "/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 401 # Unauthorized
      		end
      	end

      	context "usuario autenticado dueño de los productos" do
      		it "le permite modificar el producto con id :id" do 

      			@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

      			put "/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 204 # No Content
      			expect(PedidoProducto.count).to eq 2
      			expect(Pedido.first.productos.count).to eq 2
      			expect(Pedido.first.direccion).to eq "Carrera 10a #121-10 apt 101"
      			expect(Pedido.first.comprobante_pago).to eq "public_id"
      			expect(Pedido.first.numero_guia).to eq "1234567"
      			expect(Pedido.first.costo_total).to eq 54000
      			expect(Pedido.first.estado).to eq "nuevo"
      			expect(Pedido.first.proveedor_id).to eq @usuario_uno.id
      			expect(Pedido.first.distribuidor_id).to eq @usuario_dos.id
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).precio).to eq 9000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).cantidad).to eq 15
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).precio).to eq 20000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).cantidad).to eq 20
      		end
    	end

    	context "usuario autenticado administrador" do 
    		it "le permite modificar el pedido con id :id" do 

   				@cabeceras_peticion.merge! @admin.create_new_auth_token

      			put "/pedidos/#{@pedido_uno.id}", @parametros_pedido, @cabeceras_peticion

      			expect(response.status).to eq 204 # No Content
      			expect(PedidoProducto.count).to eq 2
      			expect(Pedido.first.productos.count).to eq 2
      			expect(Pedido.first.direccion).to eq "Carrera 10a #121-10 apt 101"
      			expect(Pedido.first.comprobante_pago).to eq "public_id"
      			expect(Pedido.first.numero_guia).to eq "1234567"
      			expect(Pedido.first.costo_total).to eq 54000
      			expect(Pedido.first.estado).to eq "nuevo"
      			expect(Pedido.first.proveedor_id).to eq @usuario_uno.id
      			expect(Pedido.first.distribuidor_id).to eq @usuario_dos.id
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).precio).to eq 9000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_dos.id).cantidad).to eq 15
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).precio).to eq 20000
      			expect(PedidoProducto.find_by(pedido_id: Pedido.first.id, producto_id: @producto_tres.id).cantidad).to eq 20
      		end
    	end
    end

    # destroy
    describe "DELETE /pedidos/:id" do
    	before :each do 
    		@usuario_uno = FactoryGirl.create :usuario_uno
    		@usuario_dos = FactoryGirl.create :usuario_dos
    		@admin = FactoryGirl.create :admin
    		@pedido_uno = FactoryGirl.create :pedido_uno
    		@producto_uno = FactoryGirl.create(:producto1, usuario_id: @usuario_uno.id)
    		@pedido_uno.save && @pedido_uno.pedidos_productos.create(:producto => @producto_uno, :cantidad => 5, :precio => 15000)
    		@usuario_uno.pedidos_distribuidor << @pedido_uno
    		expect(@usuario_uno.pedidos_distribuidor).to include @pedido_uno
    	end

    	context "usuario no autenticado" do 
    		it "no le permite eliminar el pedido con id :id" do 

    			delete "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

    			expect(response.status).to eq 401 # Unauthorized
    		end
    	end

    	context "usuario autenticado no dueño del pedido" do 
    		it "no le permite eliminar el pedido con id :id" do 

    			@cabeceras_peticion.merge! @usuario_dos.create_new_auth_token

    			delete "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

    			expect(response.status).to eq 401 # Unauthorized
    		end
    	end

    	context "usuario autenticado dueño del pedido" do 
    		it "le permite eliminar el pedido con id :id" do 

    			@cabeceras_peticion.merge! @usuario_uno.create_new_auth_token

    			delete "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

    			expect(response.status).to eq 204 #No Content
    			expect(@usuario_uno.pedidos_distribuidor.count).to eq 0
    		end
    	end

    	context "usuario autenticado administrador" do 
    		it "le permite eliminar el pedido con id :id" do 

    			@cabeceras_peticion.merge! @admin.create_new_auth_token

    			delete "/pedidos/#{@pedido_uno.id}", {}, @cabeceras_peticion

    			expect(response.status).to eq 204 #No Content
    			expect(@usuario_uno.pedidos_distribuidor.count).to eq 0
    		end
    	end
    end
end
