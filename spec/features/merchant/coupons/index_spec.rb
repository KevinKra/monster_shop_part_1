require 'rails_helper';

RSpec.describe "merchant/coupons #index" do
  before {
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
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
  
    @bike_shop.users << [@merchant_user]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    visit "/merchant/coupons"
  }

  context "page structure" do

    it "should show all current coupons belonging to the merchant" do
      within("#coupon-#{@coupon_1.id}") do
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.code)
        expect(page).to have_content(@coupon_1.active)
        expect(page).to have_content(@coupon_1.discount)
        expect(page).to have_link('delete', href: "/merchant/coupons/#{@coupon_1.id}")
      end
    end

  end

  context "Coupon creation" do
    it "merchant user is redirected to the coupon#new page" do
      within(".coupon-creation") do
        click_on "Create a Coupon"
      end
      expect(current_path).to eq("/merchant/coupons/new")
    end
  end

end