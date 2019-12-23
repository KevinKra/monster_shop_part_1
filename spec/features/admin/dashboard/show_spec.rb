require 'rails_helper'

RSpec.describe "As an admin user" do
  let!(:admin) { create(:user, :admin_user) }
  let!(:user) { create(:user, :default_user) }
  let!(:user_2) { create(:user, :default_user) }

  before :each do
    @order = user.orders.create!(current_status: 2)
    @order_2 = user_2.orders.create!
    mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = mike.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    ItemOrder.create!(order_id: @order.id, item_id: paper.id, price: paper.price, quantity: 2)
    ItemOrder.create!(order_id: @order.id, item_id: tire.id, price: tire.price, quantity: 1)
    ItemOrder.create!(order_id: @order_2.id, item_id: pencil.id, price: pencil.price, quantity: 1)

    visit "/login"

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password

    click_on "Sign In"
  end

  context 'when I visit my dashboard' do
    it 'it should display content relevant to my role' do
      expect(page).to have_content("Admin Dashboard")
      expect(current_path).to eq("/admin/dashboard")
    end

    it 'I see all orders in the system' do
      # need to add testing for orders
      # Orders are sorted by "status" in this order:
      # - packaged
      # - pending
      # - shipped
      # - cancelled
      within "#admin-order-#{@order.id}" do
        expect(page).to have_link(user.name, href: "/admin/users/#{user.id}")
        expect(page).to have_content("Order id: #{@order.id}")
        expect(page).to have_content("Created on: #{@order.created_at}")
        expect(page).to have_link("Ship Order")
      end
      within "#admin-order-#{@order_2.id}" do
        expect(page).to have_link(user_2.name, href: "/admin/users/#{user_2.id}")
        expect(page).to have_content("Order id: #{@order_2.id}")
        expect(page).to have_content("Created on: #{@order_2.created_at}")
        expect(page).not_to have_link("Ship Order")
      end
    end

    it 'I can ship a packaged order' do
      within "#admin-order-#{@order.id}" do
        click_on "Ship Order"
      end

      expect(current_path).to eq("/admin/dashboard")

      within "#admin-order-#{@order.id}" do
        expect(page).to have_link(user.name, href: "/admin/users/#{user.id}")
        expect(page).to have_content("Order id: #{@order.id}")
        expect(page).to have_content("Created on: #{@order.created_at}")
        expect(page).not_to have_link("Ship Order")
      end
    end
  end

end
