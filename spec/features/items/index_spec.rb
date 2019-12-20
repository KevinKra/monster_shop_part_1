require 'rails_helper'
# user story 17 and 18 feature tests included

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @order = Order.create!(name: "Ryan's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")
      @order_2 = Order.create!(name: "Kim's Order", address: "123", city: "pekin", state: "illinois", zip: "61554")

      @tire = @meg.items.create!(name: "Gatorskins-1", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @tire_2 = @meg.items.create!(name: "Gatorskins-2", description: "I am number 2", price: 200, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 13)
      @tire_3 = @meg.items.create!(name: "Gatorskins-3", description: "I am number 3", price: 300, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 14)
      @tire_4 = @meg.items.create!(name: "Gatorskins-4", description: "I am number 4", price: 400, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
      @tire_5 = @meg.items.create!(name: "Gatorskins-5", description: "I am number 5", price: 500, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 16)
      @tire_6 = @meg.items.create!(name: "Gatorskins-6", description: "I am number 6", price: 600, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 17)
      @tire_7 = @meg.items.create!(name: "Gatorskins-7", description: "I am number 7", price: 700, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 18)
      @tire_8 = @meg.items.create!(name: "Gatorskins-8", description: "I am number 8", price: 800, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 19)
      @tire_9 = @meg.items.create!(name: "Gatorskins-9", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
      @tire_10 = @meg.items.create!(name: "Gatorskins-9", description: "I am number 9", price: 900, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 21)


      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      ItemOrder.create!(order_id: @order.id, item_id: @tire.id, price: 100, quantity: 10)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_2.id, price: 100, quantity: 9)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_3.id, price: 100, quantity: 8)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_4.id, price: 100, quantity: 7)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_5.id, price: 100, quantity: 6)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_6.id, price: 100, quantity: 5)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_7.id, price: 100, quantity: 4)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_8.id, price: 100, quantity: 3)
      ItemOrder.create!(order_id: @order.id, item_id: @tire_9.id, price: 100, quantity: 2)
      ItemOrder.create!(order_id: @order_2.id, item_id: @tire_10.id, price: 100, quantity: 1)
    end

    it "all items, merchant names, and images are links" do

      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)

      click_on(id: "image-link-#{@tire.id}")
      expect(current_path).to eq("/items/#{@tire.id}")
    end

    describe "For different type of users" do
      let!(:user) { create(:user, :default_user) }
      let!(:admin) { create(:user, :admin_user) }
      let!(:merchant) { create(:user, :merchant_user) }
      after(:each) do
        within "#item-#{@tire.id}" do
          expect(page).to have_link(@tire.name)
          expect(page).to have_content(@tire.description)
          expect(page).to have_content("Price: $#{@tire.price}")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{@tire.inventory}")
          expect(page).to have_link(@meg.name)
          expect(page).to have_css("img[src*='#{@tire.image}']")
        end

        within "#item-#{@pull_toy.id}" do
          expect(page).to have_link(@pull_toy.name)
          expect(page).to have_content(@pull_toy.description)
          expect(page).to have_content("Price: $#{@pull_toy.price}")
          expect(page).to have_content("Active")
          expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
          expect(page).to have_link(@brian.name)
          expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        end

        # do not include disabled dog_bone on items index
        expect(page).not_to have_css("#item-#{@dog_bone.id}")
        expect(page).not_to have_link(@dog_bone.name)
        expect(page).not_to have_content(@dog_bone.description)
        expect(page).not_to have_css("img[src*='#{@dog_bone.image}']")

        # top 5 category
        within "#top-5-items" do
          expect(page).to have_content("#{@tire.name}, quantity bought: 10")
          expect(page).to have_content("#{@tire_2.name}, quantity bought: 9")
          expect(page).to have_content("#{@tire_3.name}, quantity bought: 8")
          expect(page).to have_content("#{@tire_4.name}, quantity bought: 7")
          expect(page).to have_content("#{@tire_5.name}, quantity bought: 6")
        end

        # bottom 5 category
        # within "#bottom-5-items" do
        #   expect(page).to have_content(@tire_6.name)
        #   expect(page).to have_content(@tire_7.name)
        #   expect(page).to have_content(@tire_8.name)
        #   expect(page).to have_content(@tire_9.name)
        #   expect(page).to have_content(@tire_10.name)
        #   expect(page).to have_content(@tire_6.quantity_bought)
        #   expect(page).to have_content(@tire_7.quantity_bought)
        #   expect(page).to have_content(@tire_8.quantity_bought)
        #   expect(page).to have_content(@tire_9.quantity_bought)
        #   expect(page).to have_content(@tire_10.quantity_bought)
        # end
      end

      it "As a visitor, I can see a list of all of the items " do
        visit '/items'
      end

      # it "As a user, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: user.email
      #   fill_in :password, with: user.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
      #
      # it "As an admin, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: admin.email
      #   fill_in :password, with: admin.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
      #
      # it "As a merchant, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: merchant.email
      #   fill_in :password, with: merchant.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
    end
  end
end
