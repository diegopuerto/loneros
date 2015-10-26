FactoryGirl.define do
  factory :caracteristica do
    nombre "MyString"
	  valor "MyString"
	  producto nil
  end

  factory :caracteristica_uno, class: Caracteristica do
    nombre "caracteristica_uno"
	  valor "valor_uno"
	  producto nil
  end

  factory :caracteristica_dos, class: Caracteristica do
    nombre "caracteristica_dos"
	  valor "valor_dos"
	  producto nil
  end

  factory :caracteristica_tres, class: Caracteristica do
    nombre "caracteristica_tres"
    valor "valor_tres"
    producto nil
  end

  factory :caracteristica_cuatro, class: Caracteristica do
    nombre "caracteristica_cuatro"
    valor "valor_cuatro"
  producto nil
  end

end
