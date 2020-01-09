require 'rails_helper'

describe "Merchant can view order show page for only that merchant's items" do
  let!(:merchant) { create(:user, :merchant_user) }

  describe "As a Merchant" do
    before :each do
      merchant_company = Merchant.create!(name:"Meg's Bike Shop", address: "1234 Bike cr.", city:"Denver", state: "Colorado", zip: 80221)
      merchant_company.users << merchant

      mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @pencil = mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      @tire = merchant_company.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = merchant_company.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-@paper-wide-ruled.png", inventory: 3)

      # @tire and @paper should be visible
      @ryan_order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
      @item_order_1 = ItemOrder.create!(order_id: @ryan_order.id, item_id: @tire.id, price: @tire.price, quantity: 3)
      @item_order_2 = ItemOrder.create!(order_id: @ryan_order.id, item_id: @paper.id, price: @paper.price, quantity: 4)
      @item_order_3 = ItemOrder.create!(order_id: @ryan_order.id, item_id: @pencil.id, price: @pencil.price, quantity: 2)

      # @tire should be visible
      @carley_order = Order.create!(name: "Carley's Order", address: "33323", city: "Normal", state: "illinois", zip: "71204")
      item_order_4 = ItemOrder.create!(order_id: @carley_order.id, item_id: @tire.id, price: @tire.price, quantity: 1)
      item_order_5 = ItemOrder.create!(order_id: @carley_order.id, item_id: @pencil.id, price: @pencil.price, quantity: 3)

      # order should not show
      dalton_order = Order.create!(name: "Dalton's Order", address: "9921", city: "Denver", state: "Colorado", zip: "80204")
      item_order_6 = ItemOrder.create!(order_id: dalton_order.id, item_id: @pencil.id, price: @pencil.price, quantity: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      visit '/merchant/dashboard'
    end
    describe "When I visit an order show page from my dashboard" do
      it "I see the order information and only the items for my merchant" do
        within "#merchant-orders-index-#{@ryan_order.id}" do
          click_on ("ORDER LINK(ID): #{@ryan_order.id}")
        end
        expect(current_path).to eq("/merchant/orders/#{@ryan_order.id}")

        expect(page).to have_content("Merchant Order Show View")
        expect(page).to have_content(@ryan_order.name)
        expect(page).to have_content(@ryan_order.address)
        expect(page).to have_content(@ryan_order.city)
        expect(page).to have_content(@ryan_order.state)
        expect(page).to have_content(@ryan_order.zip)

        within "#merchant-item-order-#{@item_order_1.id}" do
          expect(page).to have_link(@tire.name)
          expect(page).to have_css("img[src*='#{@tire.image}']")
          expect(page).to have_content("Price: $#{@item_order_1.price}")
          expect(page).to have_content("Quantity: #{@item_order_1.quantity}")
        end
        within "#merchant-item-order-#{@item_order_2.id}" do
          expect(page).to have_link(@paper.name)
          expect(page).to have_css("img[src*='#{@paper.image}']")
          expect(page).to have_content("Price: $#{@item_order_2.price}")
          expect(page).to have_content("Quantity: #{@item_order_2.quantity}")
        end
        expect(page).not_to have_css("#merchant-item-order-#{@pencil.id}")
        expect(page).not_to have_content(@pencil.name)
      end

      it "I can fulfill unfilled orders that have equal or less quantity on hand" do
        visit "/merchant/orders/#{@ryan_order.id}"

        within "#merchant-item-order-#{@item_order_2.id}" do
          expect(page).not_to have_link("Fulfill Item")
        end

        within "#merchant-item-order-#{@item_order_1.id}" do
          click_on("Fulfill Item")
        end

        expect(current_path).to eq("/merchant/orders/#{@ryan_order.id}")
        within "#main-flash" do
          expect(page).to have_content("Item '#{@tire.name}' has been fulfilled")
        end

        within "#merchant-item-order-#{@item_order_2.id}" do
          expect(page).not_to have_link("Fulfill Item")
        end

        within "#merchant-item-order-#{@item_order_1.id}" do
          expect(page).not_to have_link("Fulfill Item")
          expect(page).to have_content("Status: Fulfilled")
        end

        visit("/items/#{@tire.id}")
        expect(page).to have_content("Inventory: 9")
      end
    end
  end
end
