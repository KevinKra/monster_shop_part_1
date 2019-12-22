require 'rails_helper'

RSpec.describe "As a registered user" do
  let!(:user) { create(:user, :default_user) }
  before :each do
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

    visit "/cart"
    click_on "Checkout"

    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"

    @order_1 = Order.first
    @order_2 = Order.last
  end

  it "I can see all my orders on my Profile orders page" do
    expect(Order.count).to eq(2)

    within "#section-order-#{@order_1.id}" do
      expect(page).to have_content("Order id: #{@order_1.id}")
      expect(page).to have_content("Order Created: #{@order_1.created_at}")
      expect(page).to have_content("Order Updated: #{@order_1.updated_at}")
      expect(page).to have_content("Order Current Status: #{@order_1.current_status}")
      expect(page).to have_content("Order Total Quantity: #{@order_1.total_quantity}")
      expect(page).to have_content("Order Grand Total: #{@order_1.grand_total}")
    end

    within "#section-order-#{@order_2.id}" do
      expect(page).to have_content("Order id: #{@order_2.id}")
      expect(page).to have_content("Order Created: #{@order_2.created_at}")
      expect(page).to have_content("Order Updated: #{@order_2.updated_at}")
      expect(page).to have_content("Order Current Status: #{@order_2.current_status}")
      expect(page).to have_content("Order Total Quantity: #{@order_2.total_quantity}")
      expect(page).to have_content("Order Grand Total: #{@order_2.grand_total}")
    end
  end
end

# When I visit my Profile Orders page, "/profile/orders"
# I see every order I've made, which includes the following information:
# - the ID of the order, which is a link to the order show page
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - the total quantity of items in the order
# - the grand total of all items for that order
