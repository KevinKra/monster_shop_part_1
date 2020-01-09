require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @chain_2 = @bike_shop.items.create(name: "Chain Number 2", description: "It'll never break! The second one.", price: 100, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: @chain_2, price: @chain_2.price, quantity: 2)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'quantity_bought' do
      expect(@chain_2.quantity_bought).to eq(2)
    end

    it 'order count' do
      order = Order.create
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      order_2 = Order.create
      order_2.item_orders.create(item: @chain, price: @chain.price, quantity: 5)

      expect(@chain.order_count(order.id)).to eq(2)
    end

    it 'order subtotal' do
      order = Order.create
      order.item_orders.create(item: @chain, price: 200, quantity: 2)
      order_2 = Order.create
      order_2.item_orders.create(item: @chain, price: @chain.price, quantity: 5)

      expect(@chain.order_subtotal(order.id)).to eq(400)
    end

    it 'order price' do
      order = Order.create
      order.item_orders.create(item: @chain, price: 200, quantity: 2)
      order_2 = Order.create
      order_2.item_orders.create(item: @chain, price: @chain.price, quantity: 5)

      expect(@chain.order_price(order.id)).to eq(200)
    end
  end
  describe "class methods" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create!(name: "Gatorskins-1", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @tire_2 = @meg.items.create!(name: "Gatorskins-2", description: "I am number 2", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 13)
      @tire_3 = @meg.items.create!(name: "Gatorskins-3", description: "I am number 3", price: 300, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 14)
      @tire_4 = @meg.items.create!(name: "Gatorskins-4", description: "I am number 4", price: 400, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @tire_5 = @meg.items.create!(name: "Gatorskins-5", description: "I am number 5", price: 500, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 16)
      @tire_6 = @meg.items.create!(name: "Gatorskins-6", description: "I am number 6", price: 600, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 17)
      @tire_7 = @meg.items.create!(name: "Gatorskins-7", description: "I am number 7", price: 700, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 18)
      @tire_8 = @meg.items.create!(name: "Gatorskins-8", description: "I am number 8", price: 800, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 19)
      @tire_9 = @meg.items.create!(name: "Gatorskins-9", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @tire_10 = @meg.items.create!(name: "Gatorskins-10", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 21)

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
      @order_2 = Order.create!(name: "Kim's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")

      ItemOrder.create!(order_id: @order.id, item_id: @tire.id, price: 100, quantity: 10)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_2.id, price: 100, quantity: 7)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_3.id, price: 100, quantity: 8)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_4.id, price: 100, quantity: 9)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_5.id, price: 100, quantity: 6)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_6.id, price: 100, quantity: 5)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_7.id, price: 100, quantity: 4)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_8.id, price: 100, quantity: 3)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_9.id, price: 100, quantity: 2)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_10.id, price: 100, quantity: 1)


      @top_5 = [@tire, @tire_4, @tire_3, @tire_2, @tire_5]

      @bottom_5 = [@tire_10, @tire_9, @tire_8, @tire_7, @tire_6]

      @active_items = [@tire, @tire_2, @tire_3, @tire_4, @tire_5, @tire_6, @tire_7, @tire_8, @tire_9, @tire_10, @chain, @pull_toy]
    end

    it 'all_active' do
      expect(Item.all_active).to eq(@active_items)
    end

    it 'top_five_bought' do
      expect(Item.top_five_bought).to eq(@top_5)
    end

    it 'bottom_five_bought' do
      expect(Item.bottom_five_bought).to eq(@bottom_5)
    end
  end
end
