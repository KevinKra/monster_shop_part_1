require 'rails_helper'
# User Story 30, User cancels an order

RSpec.describe "As a registered user, When I visit an order's show page" do
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
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"
    click_on "Checkout"
  end
  it "I see a link to cancel the order only if the order is still pending" do
    expect(Order.count).to eq(1)
    order = Order.last

    visit "/profile/orders/#{order.id}"
    expect(page).to have_link("Cancel Order")
    # add additional testing once there is more than one current status (pending)
  end

  describe "When I click the cancel button for an order" do
    it "I am returned to my profile page" do
      expect(Order.count).to eq(1)
      order = Order.last

      visit "/profile/orders/#{order.id}"
      click_link "Cancel Order"
      expect(current_path).to eq("/profile/orders")
    end

    it "I see a flash message telling me the order is now cancelled" do
    end

    it "I see that this order now has an updated status of 'canceled'" do
    end
  end
end




# I see a button or link to cancel the order only if the order is still pending
# When I click the cancel button for an order, the following happens:
# - Each row in the "order items" table is given a status of "unfulfilled"
# - The order itself is given a status of "cancelled"
# - Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
# - I am returned to my profile page
# - I see a flash message telling me the order is now cancelled
# - And I see that this order now has an updated status of "cancelled"
