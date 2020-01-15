require "rails_helper"

RSpec.describe "Coupons#create" do
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

    visit "/items/#{@tire.id}"
    click_on "Add To Cart"

    @bike_shop.users << [@merchant_user]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
    visit "/cart"
  }

  context "coupon exists" do
    it "should allow the user to add a coupon" do
      within(".coupon-input") do
        fill_in :coupon_code, with: "533E21"
        click_on "Add Coupon"
      end
      expect(page).to have_content("Coupon Added. Checkout or continue shopping")
      expect(current_path).to eq("/cart")
    end
  end

  context "coupon doesnt exist" do
    it "should not add the coupon" do
      within(".coupon-input") do
        fill_in :coupon_code, with: "APPLE3"
        click_on "Add Coupon"
      end
      expect(page).to have_content("Hm, the coupon doesn't seem to exist")
      expect(current_path).to eq("/cart")
    end
  end
end