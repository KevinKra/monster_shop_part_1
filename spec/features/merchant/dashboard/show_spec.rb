require 'rails_helper'

RSpec.describe "As a merchant user" do
  let!(:merchant) { create(:user, :merchant_user) }
  before {
		@merchant_company = Merchant.create!(name:"Meg's Bike Shop", address: "1234 Bike cr.", city:"Denver", state: "Colorado", zip: 80221)
		@merchant_company.users << merchant

    # visit "/login"
    #
    # fill_in :email, with: merchant.email
    # fill_in :password, with: merchant.password
    #
    # click_on "Sign In"
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    visit '/merchant/dashboard'
  }

  context 'when I visit my dashboard' do
    it 'it should display content relevant to my role' do
      expect(page).to have_content("Merchant Dashboard")
    end
	end

    it 'it should display my companies name and full address' do
      expect(page).to have_content("#{@merchant_company.name}")
      expect(page).to have_content("#{@merchant_company.address}")
      expect(page).to have_content("#{@merchant_company.city}")
      expect(page).to have_content("#{@merchant_company.state}")
      expect(page).to have_content("#{@merchant_company.zip}")
    end
	end
