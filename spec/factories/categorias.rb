FactoryGirl.define do
  factory :categoria do
    nombre "MyString"
  end

  factory :categoria_uno, class: Categoria do
    nombre "categoria_uno"
  end

  factory :categoria_dos, class: Categoria do 
    nombre "categoria_dos"
  end

end
