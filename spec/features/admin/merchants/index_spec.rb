require "rails_helper"

RSpec.describe "admin/merchants#index" do
  let!(:admin) { create(:user, :admin_user) }
  let!(:merchant) { create_list(:merchant, 3) }

  before {
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    @merchant_1, @merchant_2 = create_list(:merchant, 2)
    create_list(:item, 3, merchant_id: @merchant_1.id) 
    visit "/admin/merchants"
  }

  context "as an admin visiting the merchants page" do
    it "admin should see a 'disable' button next to any merchants who are not yet disabled" do
      expect(current_path).to eq("/admin/merchants")
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_content("Disable")
      end
    end

    it "when the admin clicks the 'disable' button, they are returned to the admin's merchant index page" do
      within("#merchant-#{@merchant_1.id}") do
        click_on "Disable"
      end

      expect(current_path).to eq("/admin/merchants")

      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_content("Enable")
      end
    end

    it "the admin sees a flash message that the merchant's account is disabled/enabled" do
      within("#merchant-#{@merchant_1.id}") do
        click_on "Disable"
      end
      
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@merchant_1.name} is now Disabled")

      within("#merchant-#{@merchant_1.id}") do
        click_on "Enable"
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@merchant_1.name} is now Enabled")
    end

    it "when an admin disables a merchant, all their associated items are deactivated" do
      within("#merchant-#{@merchant_1.id}") do
        click_on "Disable"
      end

      visit "/merchants/#{@merchant_1.id}/items"

      @merchant_1.items.each do |item|
        expect(item.active?).to eq(false)
      end

      visit "/admin/merchants"

      within("#merchant-#{@merchant_1.id}") do
        click_on "Enable"
      end

      visit "/merchants/#{@merchant_1.id}/items"

      @merchant_1.reload.items.each do |item|
        expect(item.active?).to eq(true)
      end

    end
  end
end
