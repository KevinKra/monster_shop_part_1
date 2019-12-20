require 'rails_helper'
# user story 17 feature test included

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
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
      end

      it "As a visitor, I can see a list of all of the items " do
        visit '/items'
      end

      # xit "As a user, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: user.email
      #   fill_in :password, with: user.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
      #
      # xit "As an admin, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: admin.email
      #   fill_in :password, with: admin.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
      #
      # xit "As a merchant, I can see a list of all of the items "do
      #   visit "/login"
      #   fill_in :email, with: merchant.email
      #   fill_in :password, with: merchant.password
      #   click_on "Sign In"
      #   visit '/items'
      # end
    end
  end
end
