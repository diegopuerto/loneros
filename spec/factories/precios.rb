FactoryGirl.define do
  factory :precio do
    cantidad_minima 1
	  precio 1
  end

  factory :precio1, class: Precio do
    precio 1000
	  cantidad_minima 4
  end

  factory :precio2, class: Precio do
    precio 2000
	  cantidad_minima 10
  end

end
