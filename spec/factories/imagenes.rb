FactoryGirl.define do
  factory :imagen do
    public_id "MyString"
	producto nil
  end

  factory :imagen_uno, class: Imagen do
    public_id "public_id_uno"
	producto nil
  end

 factory :imagen_dos, class: Imagen do
    public_id "public_id_dos"
	producto nil
  end
end
