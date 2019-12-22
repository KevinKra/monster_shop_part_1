require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
      visit "/cart"
    end

    it 'Next to each item in my cart, I see a buttons to increment the count' do
      within "#cart-item-#{@tire.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end
      within "#cart-item-#{@pencil.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end
      within "#cart-item-#{@paper.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end
    end

    it 'I can increment the count up to the max' do
      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end
      expect(current_path).to eq('/cart')

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("2")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("3")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      expect(current_path).to eq('/cart')

      within ".error-flash" do
        expect(page).to have_content("Out of stock")
      end
    end

    it 'I can increment the item to deletion' do
      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '+'
      end

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("2")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '-'
      end

      expect(current_path).to eq('/cart')

      within "#item-quantity-#{@paper.id}" do
        expect(page).to have_content("1")
      end

      within "#cart-item-#{@paper.id}" do
        click_on '-'
      end

      expect(current_path).to eq('/cart')

      within ".notice-flash" do
        expect(page).to have_content("Item has been removed from the cart")
      end

      expect(page).not_to have_css("cart-item-#{@paper.id}")
    end

    it 'I have items in my cart, I see information telling me I must register or log in to finish checking out' do
      within ".warning-flash" do
        expect(page).to have_content("Warning: You must register or log in to finish the checkout process")
      end
    end

    # another test that the checkout is there if a user is logged in
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"
      expect(page).to_not have_link("Checkout")
    end
  end
end
