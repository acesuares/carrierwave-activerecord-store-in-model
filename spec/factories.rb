FactoryGirl.define do
  factory :apartment do
    name "Curacao_Apartment"
    description  "Nice Apartment near the ocean good for drinking Blue-Curacao"
    picture fixture_file_upload('spec/fixtures/images/Curacao-Punda-1956.jpg')  
 end
end