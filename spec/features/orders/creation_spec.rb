require 'rails_helper'
# User Story 26, Registered users can check out

RSpec.describe "As a registered user, When I add items to my cart" do
  let!(:user) { create(:user, :default_user) }

  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Sign In"

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

  end
  describe "When I add Items to my cart and visit my cart, I click the button or link to check out" do
    it "I am taken to my orders page and see my new order listed" do
      expect(current_path).to eq("/profile/orders")

      expect(Order.count).to eq(1)
      expect(page).to have_css("#order-section-#{Order.last.id}")

      within "#notice-flash" do
        expect(page).to have_content("Your order has been created.")
      end
    end

    it "My cart is now empty" do
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
