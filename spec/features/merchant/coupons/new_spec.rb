require 'rails_helper';

RSpec.describe "merchant/coupons #new" do  
  before {
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    merchant = User.create!(
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
  
    @bike_shop.users << [merchant]
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    visit "/merchant/coupons/new"
  }

  it "contains a form to create new coupons" do
    within(".create-coupon-form") do
      expect(page).to have_content("Name")
      expect(page).to have_content("Code")
      expect(page).to have_content("Discount")
      expect(page).to have_button("Create New Coupon")
    end
  end

  context "valid parameters" do
    it "creates a new coupon" do
      within(".create-coupon-form") do
        fill_in :name, with: "Flash Sale"
        fill_in :code, with: "554EE1"
        fill_in :discount, with: 25
        fill_in :active, with: "true"
        click_on "Create New Coupon"
      end
  
      expect(current_path).to eq("/merchant/coupons")

      within("#main-flash") do
        expect(page).to have_content("Coupon successfully added")
      end

    end 
  end

  context "invalid parameters" do
    it "does not create a new coupon" do
      within(".create-coupon-form") do
        fill_in :name, with: ""
        fill_in :code, with: "554EE1"
        fill_in :discount, with: 25
        fill_in :active, with: "true"
        click_on "Create New Coupon"
      end
  
      expect(current_path).to eq("/merchant/coupons")
      
      within("#main-flash") do
        expect(page).to have_content("Name can't be blank")
      end

    end 
  end

end