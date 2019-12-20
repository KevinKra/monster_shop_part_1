require 'rails_helper'

RSpec.describe 'User logging out', type: :feature do
  let!(:user) { create(:user, :default_user) }
  before {
    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Sign In"
  }
  it "they are logged in" do
    expect(current_path).to eq("/profile")
  end
  
  context 'they are currently logged in' do
    before { click_on "Logout" }


    it 'they are logged out redirected to the "/welcome/home" URI' do
      expect(current_path).to eq("/welcome/home")
    end

    it 'they see a flash message indicated they are logged out' do
      within "#main-flash" do
        expect(page).to have_content("You have been signed out.")
      end

      within "#top-nav" do
        expect(page).to have_content("Register as a User")
        expect(page).to have_content("Login")
      end
    end

    it 'their shopping cart is emptied' do
      within("#top-nav") do
        expect(page).to have_content("Cart: 0")
      end
    end

  end
end