require 'rails_helper'

describe "Merchant can activate and deactivate an item" do
  describe "As a merchant" do
    it "I see all merchant items on merchant items index view" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!",
        price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = bike_shop.items.create!(name: "Chain", description: "It'll never break!",
        price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      shifter = bike_shop.items.create!(name: "Shimano Shifters", description: "It'll always shift!",
        active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      merchant = User.create!(
        name: "Ryan",
        street_address: "123",
        city: "Pekin",
        state: "Illinois",
        zip: "61554",
        email: "merchant@gmail.com",
        password: "merchant",
        role: 2)
      bike_shop.users << [merchant]

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit '/merchant/items'

      within "#item-#{tire.id}" do
        expect(page).to have_content(tire.name)
        expect(page).to have_content("Price: $#{tire.price}")
        expect(page).to have_css("img[src*='#{tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(tire.description)
        expect(page).to have_content("Inventory: #{tire.inventory}")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
      end

      within "#item-#{chain.id}" do
        expect(page).to have_content(chain.name)
        expect(page).to have_content("Price: $#{chain.price}")
        expect(page).to have_css("img[src*='#{chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(chain.description)
        expect(page).to have_content("Inventory: #{chain.inventory}")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
      end

      within "#item-#{shifter.id}" do
        expect(page).to have_content(shifter.name)
        expect(page).to have_content("Price: $#{shifter.price}")
        expect(page).to have_css("img[src*='#{shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to have_content(shifter.description)
        expect(page).to have_content("Inventory: #{shifter.inventory}")
        expect(page).to have_link("Activate Item")
        expect(page).not_to have_link("Deactivate Item")
      end
    end
  end
end
