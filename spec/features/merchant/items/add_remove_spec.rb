require 'rails_helper'

describe "Merchant can add and remove an item" do
  before :each do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!",
      price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @bike_shop.items.create!(name: "Shimano Shifters", description: "It'll always shift!",
      active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    @order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
    ItemOrder.create!(order_id: @order.id, item_id: @shifter.id, price: @shifter.price, quantity: 1)
  end
  describe "As a Merchant" do
    before :each do
      merchant = User.create!(
        name: "Ryan",
        street_address: "123",
        city: "Pekin",
        state: "Illinois",
        zip: "61554",
        email: "merchant@gmail.com",
        password: "merchant",
        role: 2)
      @bike_shop.users << [merchant]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit '/merchant/items'
    end
    it "I see a button to delete the item next to each item that has never been ordered" do
      within "#item-#{@tire.id}" do
        expect(page).to have_button("Delete Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_button("Delete Item")
      end

      within "#item-#{@shifter.id}" do
        expect(page).not_to have_button("Delete Item")
      end
    end
    it "When I click the delete button for an item, the item is deleted and I am returned to the index" do
      within "#item-#{@tire.id}" do
        click_button("Delete Item")
        expect(current_path).to eq("/merchant/items")
      end
      within "#main-flash" do
        expect(page).to have_content("Item '#{@tire.name}' has been deleted.")
      end

        expect(page).not_to have_css("#item-#{@tire.id}")
    end
    describe "I click a button to add an item" do
      it "I see a form where I can add new information about an item" do
        within "#merchant-add-item-form" do
          expect(page).to have_content("Name:")
          expect(page).to have_content("Description:")
          expect(page).to have_content("Thumbnail Image URL:")
          expect(page).to have_content("Price:")
          expect(page).to have_content("Current Inventory:")
          expect(page).to have_button("Add Item")
        end
      end
    end
  end
end
