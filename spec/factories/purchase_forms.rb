FactoryBot.define do
  factory :purchase_form do
  

    postal_code { '123-4567' }
    prefecture { { id: Faker::Number.between(from: 0, to: 47), name: Faker::Address.state } }
    city {Faker::Address.city}
    house_number { '旭区１２３' }
    building_name {Faker::Address.building_number}
    tel {"0" + Faker::Number.between(from: 100000000, to: 9999999999).to_s}
    token { 'sample_token' }
  end
end
