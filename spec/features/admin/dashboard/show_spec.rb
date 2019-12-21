require 'rails_helper'

RSpec.describe "As an admin user" do
  let!(:admin) { create(:user, :admin_user) }
  before {
    visit "/login"

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password

    click_on "Sign In"
  }

  context 'when I visit my dashboard' do
    it 'it should display content relevant to my role' do
      expect(page).to have_content("Admin Dashboard")
      expect(page).not_to have_content("Welcome index")
    end
  end
end
