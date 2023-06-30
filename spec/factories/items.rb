FactoryBot.define do
  factory :item do
    association :user
    name { Faker::Name.unique.name }
    description { Faker::Lorem.sentence }
    price { Faker::Number.decimal(l_digits: 5, r_digits: 1) }
    category_id { rand(1..10) }
    condition_id { rand(1..6) }
    shipping_charge_id { rand(1..2) }
    shipping_date_id { rand(1..3) }
    prefecture_id { rand(1..47) }
   
    after(:build) do |item|
      item.image.attach(io: File.open(Rails.root.join('app/assets/images/furima-intro01.png')), filename: 'furima-intro01.png', content_type: 'image/png')
    end
  end
end

