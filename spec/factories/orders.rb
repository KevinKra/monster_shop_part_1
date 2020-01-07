FactoryBot.define do
  factory :order do
    name  { Faker::Number.between(from: 100, to: 50000) }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    user { :user }
    trait :pending do
      current_status { 0 }
    end
    trait :cancelled do
      current_status { 1 }
    end
    trait :packaged do
      current_status { 2 }
    end
    trait :shipped do
      current_status { 3 }
    end
  end
end