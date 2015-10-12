describe "Productos API" do

	before :each do
    @cabeceras_peticion = {
      	"Accept": "application/json",
      	 "Content-Type": "application/json"
    }
   	@producto1 = FactoryGirl.create :producto1
  end

	# index
	describe "GET /productos" do
		it "Devuelve todos los productos" do 
			producto2 = FactoryGirl.create :producto2

			get "/productos", {}, {"Accept" => "application/json"}

			expect(response.status).to eq 200 #OK

			body = JSON.parse(response.body)
			productos = body['productos']

			nombres_producto = productos.map { |m| m["nombre"] }
      		descripciones_producto = productos.map { |m| m["descripcion"] }

      		expect(nombres_producto).to match_array(["nombre_p1", "nombre_p2" ])
      		expect(descripciones_producto).to match_array(["descripcion_p1", "descripcion_p2"])
		end
	end

	# show
	describe "GET /productos/:id" do
		it "Devuelve la informacion del producto con id :id" do

			get "/productos/#{@producto1.id}", {}, { "Accept" => "application/json" }
			expect(response.status).to eq 200 #OK
			body = JSON.parse(response.body)
			producto = body['producto']
			expect(producto["nombre"]).to eq "nombre_p1"
      		expect(producto["descripcion"]).to eq "descripcion_p1"
      	end
	end

	# destroy
	describe "DELETE /productos/:id" do
		it "Elimina el producto con id :id" do

			delete "/productos/#{@producto1.id}", {}, {"Accept" => "application/json"}
			
			expect(response.status).to be 204 # No Content
      		expect(Producto.count).to eq 0
      	end
	end


	# create
	describe "POST /productos" do
		it "Crea un producto" do 

      		parametros_producto = FactoryGirl.attributes_for(:producto1).to_json

      		post "/productos", parametros_producto, @cabeceras_peticion
      		expect(response.status).to eq 201 # Created
      		expect(Producto.first.nombre).to eq @producto1.nombre
      		expect(Producto.first.descripcion).to eq @producto1.descripcion
      	end
	end

	# update
	describe "PUT /productos/:id" do
		it "Actualiza el producto con id :id" do

			parametros_producto = {
        	"nombre" => "otro_nombre",
        	"descripcion" => "otra_descripcion",
      		}.to_json

      		put "/productos/#{@producto1.id}", parametros_producto, @cabeceras_peticion

      		expect(response.status).to be 204 # No content

      		expect(Producto.first.nombre).to eq "otro_nombre"
      		expect(Producto.first.descripcion).to eq "otra_descripcion"
      	end	
	end
end