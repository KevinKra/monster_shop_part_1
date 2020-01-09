FactoryBot.define do
  factory :item_order, class: ItemOrder do
    price       {rand(1..100)}
    quantity    {rand(1..100)}
    association :item, factory: :item
    association :order, factory: :order
  end
end