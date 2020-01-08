require "rails_helper"

RSpec.describe "admin/merchants#index" do
  let!(:admin) { create(:user, :admin_user) }
  let!(:merchant) { create_list(:merchant, 5) }

  before {
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  }

  context "as an admin visiting the merchants page" do
    it "admin should see a 'disable' button next to any merchants who are not yet disabled" do
      visit "/admin/merchants" 

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Disable")
    end

    it "when the admin clicks the 'disable' button, they are returned to the admin's merchant index page" do
      visit "/admin/merchants" 

      click_on "Disable"
      
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Enable")
    end

    # it "upon visiting the merchant index page, the merchant's account is now disabled" do

    # end

    it "the admin sees a flash message that the merchant's account is disabled/enabled" do
      visit "/admin/merchants" 

      click_on "Disable"
      
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{merchant.name} is now Disabled")

      click_on "Enable"

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{merchant.name} is now Enabled")
    end
  end
end