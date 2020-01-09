FactoryBot.define do
  factory :merchant do
    name  { Faker::Name.first_name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
  end
end