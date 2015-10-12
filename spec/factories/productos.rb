FactoryGirl.define do

  factory :producto do
    nombre "MyString"
	descripcion "MyText"
  end

  factory :producto1, class: Producto do
    nombre "nombre_p1"
	  descripcion "descripcion_p1"
  end

  factory :producto2, class: Producto do
    nombre "nombre_p2"
	  descripcion "descripcion_p2"
  end
  
end
