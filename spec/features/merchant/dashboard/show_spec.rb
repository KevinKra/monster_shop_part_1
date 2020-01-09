require 'rails_helper'

RSpec.describe "As a merchant user" do
  let!(:merchant) { create(:user, :merchant_user) }

  describe 'when I visit my dashboard' do
    before :each do
      @merchant_company = Merchant.create!(name:"Meg's Bike Shop", address: "1234 Bike cr.", city:"Denver", state: "Colorado", zip: 80221)
      @merchant_company.users << merchant

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      visit '/merchant/dashboard'
    end

    it 'it should display content relevant to my role' do
      expect(page).to have_content("Merchant Dashboard")
    end
    it 'it should display my companies name and full address' do
      expect(page).to have_content("#{@merchant_company.name}")
      expect(page).to have_content("#{@merchant_company.address}")
      expect(page).to have_content("#{@merchant_company.city}")
      expect(page).to have_content("#{@merchant_company.state}")
      expect(page).to have_content("#{@merchant_company.zip}")
    end
  end

  it "My dashboard should display my merchant's orders" do
    merchant_company = Merchant.create!(name:"Meg's Bike Shop", address: "1234 Bike cr.", city:"Denver", state: "Colorado", zip: 80221)
    merchant_company.users << merchant

    mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    pencil = mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    tire = merchant_company.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = merchant_company.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    # tire and paper should be visible
    ryan_order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
    item_order_1 = ItemOrder.create!(order_id: ryan_order.id, item_id: tire.id, price: tire.price, quantity: 3)
    item_order_2 = ItemOrder.create!(order_id: ryan_order.id, item_id: paper.id, price: paper.price, quantity: 1)
    item_order_3 = ItemOrder.create!(order_id: ryan_order.id, item_id: pencil.id, price: pencil.price, quantity: 2)

    # tire should be visible
    carley_order = Order.create!(name: "Carley's Order", address: "33323", city: "Normal", state: "illinois", zip: "71204")
    item_order_4 = ItemOrder.create!(order_id: carley_order.id, item_id: tire.id, price: tire.price, quantity: 1)
    item_order_5 = ItemOrder.create!(order_id: carley_order.id, item_id: pencil.id, price: pencil.price, quantity: 3)

    # order should not show
    dalton_order = Order.create!(name: "Dalton's Order", address: "9921", city: "Denver", state: "Colorado", zip: "80204")
    item_order_6 = ItemOrder.create!(order_id: dalton_order.id, item_id: pencil.id, price: pencil.price, quantity: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    visit '/merchant/dashboard'

    within "#merchant-orders-index-#{ryan_order.id}" do
      expect(page).to have_link("ORDER LINK(ID): #{ryan_order.id}")
      # OPTIMIZE: need to add below functionality
      # expect(page).to have_content("Created at: Date")
      # expect(page).to have_content("Quantity: 4")
      # expect(page).to have_content("Grand Total: 4 times cost of each item")

      # expect(page).to have_content(ryan_order.name)
      # expect(page).to have_content(ryan_order.address)
      # expect(page).to have_content(ryan_order.city)
      # expect(page).to have_content(ryan_order.state)
      # expect(page).to have_content(ryan_order.zip)
      #
      # expect(page).to have_content(tire.name)
      # # OPTIMIZE: add test for image source
      # expect(page).to have_content(item_order_1.price)
      # expect(page).to have_content(item_order_1.quantity)
      #
      # expect(page).to have_content(paper.name)
      # # OPTIMIZE: add test for image source
      # expect(page).to have_content(item_order_2.price)
      # expect(page).to have_content(item_order_2.quantity)
    end

    within "#merchant-orders-index-#{carley_order.id}" do
      expect(page).to have_link("ORDER LINK(ID): #{carley_order.id}")

      # expect(page).to have_content(carley_order.name)
      # expect(page).to have_content(carley_order.address)
      # expect(page).to have_content(carley_order.city)
      # expect(page).to have_content(carley_order.state)
      # expect(page).to have_content(carley_order.zip)
      #
      # expect(page).to have_content(tire.name)
      # # OPTIMIZE: add test for image source
      # expect(page).to have_content(item_order_4.price)
      # expect(page).to have_content(item_order_4.quantity)
    end

    # expect(page).not_to have_content(pencil.name)
    expect(page).not_to have_css("merchant-orders-index-#{dalton_order.id}")
    expect(page).not_to have_link("ORDER LINK(ID): #{dalton_order.id}")
  end
end
