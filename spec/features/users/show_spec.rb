require 'rails_helper'

RSpec.describe "As a user when I visit my profile page" do
  let!(:user) { create(:user, :default_user) }
  before {
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Sign In"
  }

  it "I see all of my profile's data except my password" do
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.street_address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)
    expect(page).not_to have_content(user.password)
  end

  it "I see a link to edit my profile data" do

    click_on "Edit Information"

    expect(current_path).to eq("/users/#{user.id}/edit")
    expect(page).to have_content("Name")
    fill_in :name, with: "Bob Marley"
    fill_in :city, with: "Bangor"
    fill_in :password, with: user.password

    click_on "Submit Changes"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Updates saved!")
    expect(page).to have_content("Bob Marley")
    expect(page).not_to have_content(user.name)
    expect(page).to have_content(user.street_address)
    expect(page).to have_content("Bangor")
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)
  end

  it "I see a link to My Orders if I have orders" do

    expect(current_path).to eq('/profile')
    
    within ".user-dashboard" do
      expect(page).not_to have_link("My Orders")
    end

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/cart"
    click_on "Checkout"

    visit '/profile'
    within ".user-dashboard" do
      expect(page).to have_link("My Orders")
    end
  end
end
