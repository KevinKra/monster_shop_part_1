require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create!(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)

      order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
      # order.items << [@shifter]
      ItemOrder.create!(order_id: order.id, item_id: @shifter.id, price: @shifter.price, quantity: 1)

      visit "merchants/#{@meg.id}/items"
    end

    it 'shows me a list of that merchants items' do
      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).not_to have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
        expect(page).to have_link("Delete Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).not_to have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
        expect(page).to have_link("Delete Item")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).not_to have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
        expect(page).to have_link("Activate Item")
        expect(page).not_to have_link("Deactivate Item")
        expect(page).not_to have_link("Delete Item")
      end
    end

    it 'I click Deactivate Item and item is then deactivated' do
      within "#item-#{@chain.id}" do
        click_link 'Deactivate Item'
      end

      expect(current_path).to eq("/merchants/#{@meg.id}/items")

      within "#main-flash" do
        expect(page).to have_content("Item #{@chain.name} has been deactivated.")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Active")
        expect(page).to have_link("Deactivate Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content("Inactive")
        expect(page).not_to have_link("Deactivate Item")
      end
    end

    it 'I click activate Item and item is then deactivated' do
      within "#item-#{@shifter.id}" do
        click_link 'Activate Item'
      end

      expect(current_path).to eq("/merchants/#{@meg.id}/items")

      within "#main-flash" do
        expect(page).to have_content("Item #{@shifter.name} has been activated.")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_content("Active")
        expect(page).to have_link("Deactivate Item")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content("Active")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
      end
    end

    it "I click delete and the item is deleted" do
      within "#item-#{@tire.id}" do
        click_link("Delete Item")
      end

      expect(current_path).to eq("/merchants/#{@meg.id}/items")

      within "#main-flash" do
        expect(page).to have_content("Item #{@tire.name} has been deleted.")
      end

      expect(page).not_to have_css("#item-#{@tire.id}")

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).not_to have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
        expect(page).to have_link("Activate Item")
        expect(page).not_to have_link("Deactivate Item")
        expect(page).not_to have_link("Delete Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).not_to have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
        expect(page).to have_link("Deactivate Item")
        expect(page).not_to have_link("Activate Item")
        expect(page).to have_link("Delete Item")
      end
    end
  end
end
