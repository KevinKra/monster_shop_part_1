require 'rails_helper'

describe "Merchant can edit an item" do
  let!(:user) { create(:user, :default_user) }
  before :each do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
      price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!",
      price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @shifter = @bike_shop.items.create!(name: "Shimano Shifters", description: "It'll always shift!",
      active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    @order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554", user: user)
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
    describe "When I click the edit button for an item" do
      it "I can adjust item information then submit the changes" do
        within "#item-#{@tire.id}" do
          click_link 'Edit Item'
        end

        expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

        fill_in 'Description', with: "There is a new version of this item."
        fill_in 'Inventory', with: "5"
        click_on "Update Item"

        expect(current_path).to eq("/merchant/items")

        within "#main-flash" do
          expect(page).to have_content("Item '#{@tire.name}' has been updated.")
        end
        within "#item-#{@tire.id}" do
          expect(page).not_to have_content("Inventory: 12")
          expect(page).not_to have_content("They'll never pop!")
          expect(page).to have_content("There is a new version of this item.")
          expect(page).to have_content(@tire.name)
          expect(page).to have_content("Price: $#{@tire.price}")
          expect(page).to have_css("img[src*='#{@tire.image}']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: 5")
          expect(page).to have_link("Deactivate Item")
          expect(page).not_to have_link("Activate Item")
        end
      end

      it "I can not delete out validated information" do
        within "#item-#{@tire.id}" do
          click_link 'Edit Item'
        end

        expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

        fill_in 'Description', with: ""
        fill_in 'Inventory', with: ""
        click_on "Update Item"

        expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

        within "#main-flash" do
          expect(page).to have_content("Description can't be blank, Inventory can't be blank, and Inventory is not a number")
        end
        # OPTIMIZE: add testing that fields are still filled out correctly, this is implemented and tested on development
      end

      it "I can not adjust inventory or price to non valid input" do
        within "#item-#{@tire.id}" do
          click_link 'Edit Item'
        end

        expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

        fill_in 'Inventory', with: "-1"
        fill_in 'Price', with: "0"
        click_on "Update Item"

        expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

        within "#main-flash" do
          expect(page).to have_content("Price must be greater than 0 and Inventory must be greater than or equal to 0")
        end
      end
    end
  end
end
