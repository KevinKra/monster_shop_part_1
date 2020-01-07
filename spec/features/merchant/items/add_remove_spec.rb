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
        expect(page).to have_link("Delete Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_link("Delete Item")
      end

      within "#item-#{@shifter.id}" do
        expect(page).not_to have_link("Delete Item")
      end
    end
    it "When I click the delete button for an item, the item is deleted and I am returned to the index" do
      within "#item-#{@tire.id}" do
        click_link("Delete Item")
        expect(current_path).to eq("/merchant/items")
      end
      within "#main-flash" do
        expect(page).to have_content("Item '#{@tire.name}' has been deleted.")
      end

        expect(page).not_to have_css("#item-#{@tire.id}")
    end
    describe "When I click a button to add an item" do
      it "I see a form where I can add new information about an item" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")
        expect(page).to have_content("Merchant Items New View")
        within "#merchant-add-item-form" do
          expect(page).to have_content("Name")
          expect(page).to have_content("Description")
          expect(page).to have_content("Thumbnail Image URL")
          expect(page).to have_content("Price")
          expect(page).to have_content("Current Inventory")
          expect(page).to have_button("Create Item")
        end
      end

      it "When I add valid information and submit the form, the Item is added" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: "MacBook Pro"
        fill_in 'Description', with: "Over priced laptop."
        fill_in 'Price', with: "12000.00"
        fill_in 'Thumbnail Image URL', with: "https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjd9Z6Gh_LmAhXKGc0KHRl-CxIQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.cnet.com%2Freviews%2Fapple-macbook-pro-with-touch-bar-15-inch-2018-review%2F&psig=AOvVaw1JT7voS2inioj9Tg6tSP11&ust=1578505950629074"
        fill_in 'Inventory', with: "1"
        click_on "Create Item"

        item = Item.last
        expect(current_path).to eq("/merchant/items")

        within("#main-flash") do
          expect(page).to have_content("Item 'MacBook Pro' is now for sale.")
        end
        within "#item-#{item.id}" do
          expect(page).to have_content("MacBook Pro")
          expect(page).to have_content("Price: $12,000.00")
          expect(page).to have_css("img[src*='url?sa=i&source=images&cd=&ved=2ahUKEwjd9Z6Gh_LmAhXKGc0KHRl-CxIQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.cnet.com%2Freviews%2Fapple-macbook-pro-with-touch-bar-15-inch-2018-review%2F&psig=AOvVaw1JT7voS2inioj9Tg6tSP11&ust=1578505950629074']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Over priced laptop.")
          expect(page).to have_content("Inventory: 1")
          expect(page).to have_link("Deactivate Item")
          expect(page).not_to have_link("Activate Item")
          expect(page).to have_link("Delete Item")
        end
      end
      it "When I add valid information but not an Image URL and submit the form, the Item is added" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: "MacBook Pro"
        fill_in 'Description', with: "Over priced laptop."
        fill_in 'Price', with: "12000.00"
        fill_in 'Inventory', with: "1"
        click_on "Create Item"

        item = Item.last
        expect(current_path).to eq("/merchant/items")

        within("#main-flash") do
          expect(page).to have_content("Item 'MacBook Pro' is now for sale.")
        end
        within "#item-#{item.id}" do
          expect(page).to have_content("MacBook Pro")
          expect(page).to have_content("Price: $12,000.00")
          expect(page).to have_css("img[src*='Default-Image-ValueWalk.jpg']")
          expect(page).to have_content("Active")
          expect(page).to have_content("Over priced laptop.")
          expect(page).to have_content("Inventory: 1")
          expect(page).to have_link("Deactivate Item")
          expect(page).not_to have_link("Activate Item")
          expect(page).to have_link("Delete Item")
        end
      end

      it "When I enter invalid price the Item is not created" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: "MacBook Pro"
        fill_in 'Description', with: "Over priced laptop."
        fill_in 'Price', with: "-10000.00"
        fill_in 'Inventory', with: "1"
        click_on "Create Item"

        expect(current_path).to eq("/merchant/items/new")

        within("#main-flash") do
          expect(page).to have_content("Price must be greater than 0")
        end
      end
      it "When I enter invalid quantity the Item is not created" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        fill_in 'Name', with: "MacBook Pro"
        fill_in 'Description', with: "Over priced laptop."
        fill_in 'Price', with: "10000.00"
        fill_in 'Inventory', with: "-2"
        click_on "Create Item"

        expect(current_path).to eq("/merchant/items/new")

        within("#main-flash") do
          expect(page).to have_content("Inventory must be greater than or equal to 0")
        end
      end
      it "When I don't enter information the Item is not created" do
        click_button "Add New Item"
        expect(current_path).to eq("/merchant/items/new")

        click_on "Create Item"

        expect(current_path).to eq("/merchant/items/new")

        within("#main-flash") do
          expect(page).to have_content("Name can't be blank, Description can't be blank, Price can't be blank, Price is not a number, Inventory can't be blank, and Inventory is not a number")
        end
      end
    end
  end
end
