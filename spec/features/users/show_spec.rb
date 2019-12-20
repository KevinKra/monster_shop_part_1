require 'rails_helper'

RSpec.describe "As a user when I visit my profile page" do
  let!(:user) { create(:user, :default_user) }
  before {
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
    expect(page).to have_content(user.role)
  end

  it "I see a link to edit my profile data" do
    click_on "Edit Information"

    expect(current_path).to eq("/users/#{user.id}/edit")
    expect(page).to have_button("Submit Changes")

    fill_in :password, with: user.password

    click_button "Submit Changes"

    expect(current_path).to eq("/users/profile")
    expect(page).to have_content("Updates saved!")
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.street_address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.role)
  end
end
