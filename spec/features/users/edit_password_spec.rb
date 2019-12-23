require 'rails_helper'

RSpec.describe "As a User" do
	let!(:user) { create(:user, :default_user) }
  before {
    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Sign In"
  }


  context 'when I visit my dashboard' do
    it 'it should display content relevant to my role' do
      expect(page).to have_content("My Profile")
			expect(page).to have_button("Edit Password")
    end
  end

		it "I am directed to the new Password Form to complete my request" do
			visit '/profile'

			expect(current_path).to eq('/profile')

			click_on 'Edit Password'

			expect(current_path).to eq("/profile/edit_password")
			expect(page).to have_content("Password")
			expect(page).to have_content("Password confirmation")

			fill_in :password, with: 'user2'
			fill_in :password_confirmation, with: 'user2'

			click_button "Change Password"

			expect(current_path).to eq('/profile')
			expect(page).to have_content('Your Password has been updated!')

			click_on "Logout"

			visit "/login"

			fill_in :email, with: user.email
			fill_in :password, with: 'user2'

			click_on "Sign In"

			expect(current_path).to eq("/profile")
		end

		it "I am redirected the new Password Form to complete my request" do
			visit '/profile'
			click_on 'Edit Password'

			expect(current_path).to eq("/profile/edit_password")
			expect(page).to have_content("Password")
			expect(page).to have_content("Password confirmation")

			fill_in :password, with: 'user2'
			fill_in :password_confirmation, with: 'user1'

			click_button "Change Password"

			expect(current_path).to eq('/profile/edit_password')
			expect(page).to have_content('The Password you entered did not match, Please try again')
		end
	end
