require 'rails_helper'

RSpec.describe 'User logging in' do
  let(:user) { create(:user, :default_user) }
  let(:admin) { create(:user, :admin_user) }
  let(:merchant) { create(:user, :merchant_user) }
  before { visit "/login" }

  context 'with valid credentials' do

    context 'user is an admin' do
      before {
        fill_in :email, with: admin.email
        fill_in :password, with: admin.password

        click_on "Sign In"
      }
      it 'they can sign in' do
        expect(current_path).to eq("/admin/dashboard")
      end

      it 'they see a welcome flash message' do
        within("#main-flash") do
          expect(page).to have_content("Welcome, #{admin.name}. You are logged in as an Admin.")
          expect(page).to_not have_content("Welcome, #{merchant.name}. You are logged in as a Merchant.")
          expect(page).to_not have_content("Welcome, #{user.name}.")
        end
      end
    end

    context 'user is a merchant' do
      before {
        fill_in :email, with: merchant.email
        fill_in :password, with: merchant.password

        click_on "Sign In"
      }
      it 'they can sign in' do
        expect(current_path).to eq("/merchants/dashboard")
      end

      it 'they see a welcome flash message' do
        within("#main-flash") do
          expect(page).to have_content("Welcome, #{merchant.name}. You are logged in as a Merchant.")
          expect(page).to_not have_content("Welcome, #{admin.name}. You are logged in as an Admin.")
          expect(page).to_not have_content("Welcome, #{user.name}.")
        end
      end
    end

    context 'user is a default user' do
      before {
        fill_in :email, with: user.email
        fill_in :password, with: user.password

        click_on "Sign In"
      }
      it 'they can sign in' do
        expect(current_path).to eq("/profile")
      end

      it 'they see a welcome flash message' do
        within("#main-flash") do
          expect(page).to have_content("Welcome, #{user.name}.")
          expect(page).to_not have_content("Welcome, #{admin.name}. You are logged in as an Admin.")
          expect(page).to_not have_content("Welcome, #{merchant.name}. You are logged in as a Merchant.")
        end
      end
    end
  end

  context 'with invalid credentials' do

    describe 'prevents them from logging in' do
      before(:each) { fill_in :password, with: "wrongPassword" }
      after(:each) do
        click_on "Sign In"
        expect(current_path).to eq("/login")
        within("#main-flash") do
          expect(page).to have_content("Sorry, wrong username or password.")
        end
      end

      it 'as an admin' do
        fill_in :email, with: admin.email
      end

      it 'as a merchant' do
        fill_in :email, with: merchant.email
      end

      it 'as a user' do
        fill_in :email, with: user.email
      end
    end
  end

  context 'they are already logged in' do

    describe 'they are redirected' do
      after(:each) {
        within '#main-flash' do
          expect(page).to have_content("You are already logged in.")
        end
      }

      it 'if an admin, back to their admin dashboard' do
        fill_in :email, with: admin.email
        fill_in :password, with: admin.password
        click_on "Sign In"

        visit "/login"
        expect(current_path).to eq("/admin/dashboard")
      end

      it 'if an merchant, back to their merchant dashboard' do
        fill_in :email, with: merchant.email
        fill_in :password, with: merchant.password
        click_on "Sign In"

        visit "/login"
        expect(current_path).to eq("/merchants/dashboard")
      end

      it 'if an user, back to their user dashboard' do
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_on "Sign In"

        visit "/login"
        expect(current_path).to eq("/profile")
      end

    end
  end
end
