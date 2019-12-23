Merchant.destroy_all
User.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins-1", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
tire_2 = bike_shop.items.create!(name: "Gatorskins-2", description: "I am number 2", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 13)
tire_3 = bike_shop.items.create!(name: "Gatorskins-3", description: "I am number 3", price: 300, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 14)
tire_4 = bike_shop.items.create!(name: "Gatorskins-4", description: "I am number 4", price: 400, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
tire_5 = bike_shop.items.create!(name: "Gatorskins-5", description: "I am number 5", price: 500, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 16)
tire_6 = bike_shop.items.create!(name: "Gatorskins-6", description: "I am number 6", price: 600, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 17)
tire_7 = bike_shop.items.create!(name: "Gatorskins-7", description: "I am number 7", price: 700, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 18)
tire_8 = bike_shop.items.create!(name: "Gatorskins-8", description: "I am number 8", price: 800, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 19)
tire_9 = bike_shop.items.create!(name: "Gatorskins-9", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
tire_10 = bike_shop.items.create!(name: "Gatorskins-10", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 21)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#orders
order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")

#itemorders
ItemOrder.create!(order_id: order.id, item_id: tire.id, price: 100, quantity: 1)
ItemOrder.create!(order_id: order.id, item_id: tire_2.id, price: 100, quantity: 3)
ItemOrder.create!(order_id: order.id, item_id: tire_3.id, price: 100, quantity: 8)
ItemOrder.create!(order_id: order.id, item_id: tire_4.id, price: 100, quantity: 7)
ItemOrder.create!(order_id: order.id, item_id: tire_5.id, price: 100, quantity: 4)
ItemOrder.create!(order_id: order.id, item_id: tire_6.id, price: 100, quantity: 5)
ItemOrder.create!(order_id: order.id, item_id: tire_7.id, price: 100, quantity: 14)
ItemOrder.create!(order_id: order.id, item_id: tire_8.id, price: 100, quantity: 5)
ItemOrder.create!(order_id: order.id, item_id: tire_9.id, price: 100, quantity: 21)
ItemOrder.create!(order_id: order.id, item_id: tire_10.id, price: 100, quantity: 1)

user = User.create(
  name:  Faker::Name.first_name,
  street_address: Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state,
  zip: Faker::Address.zip,
  email: "user@gmail.com",
  password: "user",
  role: 0
)
admin = User.create(
    name:  Faker::Name.first_name,
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip,
    email: "admin@gmail.com",
    password: "admin",
    role: 1
)
merchant = User.create(
    name:  Faker::Name.first_name,
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip,
    email: "merchant@gmail.com",
    password: "merchant",
    role: 2
)

bike_shop.users << [merchant]
