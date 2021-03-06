require 'rails_helper';

RSpec.describe "merchant/coupons #destroy" do
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
      role: 2
    )
    @coupon_1 = Coupon.create(
      name: "Christmas Special",
      code: "533E21",
      active: true,
      discount: 25,
      merchant: @bike_shop
    )
    @coupon_2 = Coupon.create(
      name: "Christmas Special 2",
      code: "522E21",
      active: true,
      discount: 25,
      merchant: @bike_shop
    )

    @order_1 = Order.create!(
      name: 'Meg', 
      address: '123 Stang Ave',
      city: 'Hershey',
      state: 'PA',
      zip: 17033,
      user: @default_user,
      coupon: @coupon_1
    )
  
    @bike_shop.users << [@merchant_user]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    visit "/merchant/coupons"
  }

  context "Coupon deletion" do
    it "merchant user is able to delete coupon if its not in use" do
      expect(@merchant_user.merchant.coupons.count).to eq(2)
      within("#coupon-#{@coupon_2.id}") do
        click_on "delete"
      end
      expect(current_path).to eq("/merchant/coupons")
      expect(page).to have_content("Coupon successfully deleted")
      expect(@merchant_user.merchant.coupons.count).to eq(1)
    end

    it "merchant user is not able to delete coupon if its in use" do
      expect(@merchant_user.merchant.coupons.count).to eq(2)
      within("#coupon-#{@coupon_1.id}") do
        click_on "delete"
      end
      expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}")
      expect(page).to have_content("Coupon is currently being used in an order")
      expect(@merchant_user.merchant.coupons.count).to eq(2)
    end

  end

end