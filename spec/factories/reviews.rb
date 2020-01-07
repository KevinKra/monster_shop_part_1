FactoryBot.define do
  factory :review do
    title  { Faker::Hipster.sentence(word_count: 3) }
    content { Faker::Hipster.paragraph }
    rating { Faker::Number.between(from: 0, to: 5) }
    item { :item }
  end
end