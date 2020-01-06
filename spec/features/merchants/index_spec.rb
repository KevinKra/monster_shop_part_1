require 'rails_helper'

RSpec.describe 'merchant#index', type: :feature do
  let!(:user) { create(:user, :default_user) }
  let!(:merchant) { create(:user, :merchant_user) }
  let!(:admin) { create(:user, :admin_user) }

  it "user clicks New Merchant button" do
    visit "/merchants"
    click_on "New Merchant"
    expect(current_path).to eq("/merchants/new")
  end

  before {
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
  }

  describe "structure for all user types" do
    after {
        visit "/merchants"
        expect(page).to have_link("Brian's Bike Shop")
        expect(page).to have_link("Meg's Dog Shop")
        expect(page).to have_link("New Merchant")
    }

    context "as a visitor" do
      it "they visit the merchants page" do
      end
    end

    context "as a user" do
      it "user logs in" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end
    end

    context "as a merchant" do
      it "merchant logs in" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      end
    end

    context "as an admin" do
      it "admin logs in" do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      end
    end

  end

  # context "As an admin" do
  #   before {

  #   }
  # end

end
