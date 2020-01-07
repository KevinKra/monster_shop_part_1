FactoryBot.define do
  factory :item do
    name { Faker::Coffee.blend_name }
    description { Faker::Lorem.sentence(word_count: 10) }
    price { Faker::Number.between(from: 100, to: 50000) }
    image { "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588" }
    inventory { Faker::Number.between(from: 1, to: 200) }
    merchant { :merchant }
  end
end