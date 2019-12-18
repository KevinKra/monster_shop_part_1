require 'rails_helper'

RSpec.describe "As an merchant" do
  it "I go to my merchant profile page" do
    merchant = User.create(
      name: "Joey",
      street_address: "123 Five Street",
      city: "Denver",
      state: "CO",
      zip: "80210",
      email: "fake@gmail.com",
      password: "wordpass",
      role: 2
    )

    visit "/login"

    fill_in :email, with: merchant.email
    fill_in :password, with: "wordpass"

    click_on "Login"

    expect(current_path).to eq("/merchants/profile")
    expect(page).to have_content("Welcome, user. You are the Merchant.")
    expect(page).to have_content("Welcome, #{merchant.name}!")
  end
end