require 'rails_helper'

RSpec.describe "As a merchant user" do
  let!(:merchant) { create(:user, :merchant_user) }
  before {
    visit "/login"

    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password

    click_on "Sign In"
  }

  context 'when I visit my dashboard' do
    it 'it should display content relevant to my role' do
      expect(page).to have_content("Merchant Dashboard")
      expect(page).not_to have_content("Welcome index")
    end
  end

end
