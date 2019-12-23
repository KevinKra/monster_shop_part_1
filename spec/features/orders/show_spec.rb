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
    order = Order.last

    visit '/profile/orders'
    within("#section-order-#{Order.last.id}") do
      click_link(Order.last.id)
    end

    expect(current_path).to eq("/profile/orders/#{Order.last.id}")
    expect(page).to have_content("Order id: #{order.id}")
    expect(page).to have_content("Order Created: #{order.created_at}")
    expect(page).to have_content("Order Updated: #{order.updated_at}")
    expect(page).to have_content("Order Current Status: #{order.current_status}")
    expect(page).to have_content("Order Total Quantity: #{order.total_quantity}")
    expect(page).to have_content("Order Grand Total: #{order.grand_total}")

    within "#order-item-#{@tire.id}" do
      expect(page).to have_content("Item Name: #{@tire.name}")
      expect(page).to have_content("Item Description: #{@tire.description}")
      expect(page).to have_content("Item Order Count: 1")
      expect(page).to have_content("Item Price: 100")
      expect(page).to have_content("Item Order Subtotal: 100")
    end

    within "#order-item-#{@pencil.id}" do
      expect(page).to have_content("Item Name: #{@pencil.name}")
      expect(page).to have_content("Item Description: #{@pencil.description}")
      expect(page).to have_content("Item Order Count: 1")
      expect(page).to have_content("Item Price: 2")
      expect(page).to have_content("Item Order Subtotal: 2")
    end
  end
end
