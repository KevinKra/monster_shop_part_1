require 'rails_helper'

RSpec.describe "As a registered User, I can view an order show page" do
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

    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"
  end

  it "I click on the id link from the Order Index Page and redirect to the Show Page" do
    visit '/profile/orders'
    order = Order.last
    within("#section-order-#{Order.last.id}") do
      click_link(Order.last.id)
    end

    expect(current_path).to eq("/profile/orders/#{Order.last.id}")
    expect(page).to have_content("Order id: #{order.id}")
    expect(page).to have_content("Order Created: #{order.created_at}")
    expect(page).to have_content("Order Updated: #{order.updated_at}")
    expect(page).to have_content("Order Current Status: #{order.current_status}")
    expect(page).to have_content("Order Total Quantity: #{order.total_quantity}")
    expect(page).to have_content("Order Grand Total: #{order.grand_total}")  end
end

# As a registered user
# When I visit my Profile Orders page
# And I click on a link for order's show page
# My URL route is now something like "/profile/orders/15"
# I see all information about the order, including the following information:
# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item I ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order
