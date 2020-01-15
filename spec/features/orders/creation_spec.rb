require 'rails_helper'
# User Story 26, Registered users can check out

RSpec.describe "As a registered user, When I add items to my cart" do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @tire_2 = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
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
      code: "25OFF",
      active: true,
      discount: 25,
      merchant: @bike_shop
    )
    @order_1 = Order.create!(
      name: 'Order_1', 
      address: '123 Stang Ave',
      city: 'Hershey',
      state: 'PA',
      zip: 17033,
      user: @default_user,
      coupon: @coupon_1
    )

    @bike_shop.users << [@merchant_user]

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@default_user)
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire_2.id}"
    click_on "Add To Cart"

    visit "/cart"

  end

  describe "When I add Items to my cart and visit my cart, I click the button or link to check out" do

    context "if coupon exists" do
      before {
        within(".coupon-input") do
          fill_in :coupon_code, with: "25OFF"
          click_on "Add Coupon"
        end
        click_on "Checkout"
      }

      it "should display the discount total" do
        expect(current_path).to eq("/profile/orders")
        within("#section-order-#{Order.last.id}") do
          expect(page).to have_content(262.0)
        end
      end
    end

    context "if coupon does not exist" do
      before {
        within(".coupon-input") do
          fill_in :coupon_code, with: "FAKECOUPON"
          click_on "Add Coupon"
        end
        click_on "Checkout"
      }

      it "should display the original total" do
        expect(current_path).to eq("/profile/orders")
        within("#section-order-#{Order.last.id}") do
          expect(page).to have_content(350.0)
        end
      end
    end

    it "I see a flash message indicating the order has been created" do
      within(".coupon-input") do
        fill_in :coupon_code, with: "FAKECOUPON"
        click_on "Add Coupon"
      end
      click_on "Checkout"

      expect(current_path).to eq("/profile/orders")

      expect(Order.count).to eq(2)
      expect(page).to have_css("#section-order-#{Order.last.id}")

      within ".notice-flash" do
        expect(page).to have_content("Your order has been created.")
      end
    end

    it "My cart is now empty" do
      click_on "Checkout"
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
