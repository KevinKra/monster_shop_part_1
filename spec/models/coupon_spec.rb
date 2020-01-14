require 'rails_helper';

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
    it { should validate_inclusion_of(:discount).in_range(0..100)}
  end

  describe "uniqueness" do
    it { should validate_uniqueness_of :code }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end

  describe "instance methods" do
    before {
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
        price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @default_user = User.create!(
        name: "Arbies",
        street_address: "321",
        city: "Pekin",
        state: "Illinois",
        zip: "61554",
        email: "default@gmail.com",
        password: "default",
        role: 0)
      @merchant_user = User.create!(
        name: "Ryan",
        street_address: "123",
        city: "Pekin",
        state: "Illinois",
        zip: "61554",
        email: "merchant@gmail.com",
        password: "merchant",
        role: 2)
      @coupon_1 = Coupon.create(
        name: "Christmas Special",
        code: "533E21",
        active: true,
        discount: 25,
        merchant: @bike_shop
      )
      @coupon_2 = Coupon.create!(
        name: "Christmas Special 2",
        code: "533E23",
        active: true,
        discount: 15,
        merchant: @bike_shop
      )
    
      @bike_shop.users << [@merchant_user]

      @order_1 = Order.create!(
        name: 'Meg', 
        address: '123 Stang Ave',
        city: 'Hershey',
        state: 'PA',
        zip: 17033,
        user: @default_user,
        coupon: @coupon_2
      )
    }

    it "not_in_use?" do
      expect(@coupon_1.not_in_use?).to eq(true)
      expect(@coupon_2.not_in_use?).to eq(false)
    end
  end
end