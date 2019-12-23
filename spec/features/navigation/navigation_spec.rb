require 'rails_helper'

RSpec.describe 'Site Navigation' do
  let!(:user) { create(:user, :default_user) }
  let!(:merchant) { create(:user, :merchant_user) }
  let!(:admin) { create(:user, :admin_user) }

  before { visit "/login" }

  describe 'when I visit any page I see the navbar' do
    after(:each) do
      within('#top-nav') do
        expect(page).to have_link("Home", href: "/")
        expect(page).to have_link("All Merchants", href: "/merchants")
        expect(page).to have_link("All Items", href: "/items")
      end
    end

    it 'all user types should have functioning default links' do
      # See above after(:each)
    end

    context 'as a visitor' do
      it 'should also include login and register links' do
        expect(page).to have_link("Login", href: "/login")
        expect(page).to have_link("Register", href: "/register")
      end

      # Path Restrictions
      describe "when I try to access any path that begins with /profile, /merchant, /admin" do
        it "I see a 404 error" do
          visit '/profile'
          expect(page).to have_content("Error 404: You don't have access to this section.")

          visit '/merchant'
          expect(page).to have_content("Error 404: You don't have access to this section.")

          visit '/admin'
          expect(page).to have_content("Error 404: You don't have access to this section.")
        end
      end

    end

    describe 'logged in Users, Merchants, Admins' do
      after(:each) do
        within('#top-nav') do
          expect(page).to have_link("Logout", href: "/logout")
          expect(page).to_not have_link("Login", href: "/login")
          expect(page).to_not have_link("Register", href: "/register")
        end
      end

      context 'as a logged in user' do
        before {
          fill_in :email, with: user.email
          fill_in :password, with: user.password
          click_on "Sign In"

          expect(page).to_not have_link("Login", href: "/login")
          expect(page).to_not have_link("Register", href: "/register")
        }

        it 'should include a link to the user profile dashboard' do
          expect(page).to have_link("My Profile", href: "/profile")
        end

        it 'should display a cart button' do
          expect(page).to have_link("Cart: 0", href: "/cart")
        end

        it 'should not have higher privileged buttons' do
          expect(page).to_not have_link("Admin Dashboard", href: "/admin")
          expect(page).to_not have_link("View All Users", href: "/admin/users")
        end

        it 'should display a message stating that the user is logged in' do
          expect(page).to have_content("Logged in as #{user.name}")
        end

        # Path Restrictions
        describe "When I try to access any path that begins with /merchant or /admin" do
          it "I see a 404 error" do
            visit '/merchant'
            expect(page).to have_content("Error 404: You don't have access to this section.")

            visit '/admin'
            expect(page).to have_content("Error 404: You don't have access to this section.")
          end
        end
      end

      context 'as a merchant' do
        before {
					@bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
					@bike_shop.users << [merchant]

          fill_in :email, with: merchant.email
          fill_in :password, with: merchant.password
          click_on "Sign In"
        }

        it 'should include a link to the merchant dashboard' do
          expect(page).to have_link("Merchant Dashboard", href: "/merchants/dashboard")
        end

        it 'should display a cart button' do
          expect(page).to have_link("Cart: 0", href: "/cart")
        end

        it 'should not have higher privileged buttons' do
          expect(page).to_not have_link("Admin Dashboard", href: "/admin")
          expect(page).to_not have_link("View All Users", href: "/admin/users")
        end

        # Path Restrictions
        describe "When I try to access any path that begins with /admin" do
          it "I see a 404 error" do
            visit '/admin'
            expect(page).to have_content("Error 404: You don't have access to this section.")
          end
        end

      end

      context 'as an admin', :admin do
        before {
          fill_in :email, with: admin.email
          fill_in :password, with: admin.password
          click_on "Sign In"
        }

        it 'should include a link to the admin dashboard and the all users page' do
          expect(page).to have_link("Admin Dashboard", href: "/admin")
          expect(page).to have_link("View All Users", href: "/admin/users")
        end

        it 'should not display a cart button' do
          expect(page).to_not have_link("Cart: 0", href: "/cart")
        end

        it 'should not have merchant buttons' do
          expect(page).to_not have_link("Merchant Dashboard", href: "/merchants/dashboard")
        end

        # Path Restrictions
        describe "When I try to access any path that begins with /merchant, /cart" do
          it "I see a 404 error for /merchant" do
            visit '/merchant'
            expect(page).to have_content("Error 404: You don't have access to this section.")
          end

          it "I see a 404 error for /cart" do
            visit '/cart'
            expect(page).to have_content("Error 404: You don't have access to this section.")
          end
        end
      end
    end

  end
end
