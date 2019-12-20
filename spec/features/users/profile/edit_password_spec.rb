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
      expect(page).to have_content("User Profile")
			expect(page).to have_button("Edit Password")
    end
  end

		it "I am directed to the new Password Form to complete my request" do
			user = User.create(
			  name:  Faker::Name.first_name,
			  street_address: Faker::Address.street_address,
			  city: Faker::Address.city,
			  state: Faker::Address.state,
			  zip: Faker::Address.zip,
			  email: "user@gmail.com",
			  password: "user",
			  role: 0
			)

			visit '/users/profile'

			expect(current_path).to eq('/users/profile')

			click_on 'Edit Password'

			expect(current_path).to eq("/users/profile/edit_password")
			expect(page).to have_content("Password")
			expect(page).to have_content("Password confirmation")

			fill_in :password, with: 'user2'
			fill_in :password_confirmation, with: 'user2'

			click_button "Change Password"

			expect(current_path).to eq('/users/profile')
			expect(page).to have_content('Your Password has been updated!')
		end

		it "I am directed to the new Password Form to complete my request" do

			click_on 'Edit Password'

			expect(current_path).to eq("/users/profile/edit_password")
			expect(page).to have_content("Password")
			expect(page).to have_content("Password confirmation")

			fill_in :password, with: 'user2'
			fill_in :password_confirmation, with: 'user1'

			click_button "Change Password"

			expect(current_path).to eq('/users/profile/edit_password')
			expect(page).to have_content('The Password you entered did not match, Please try again')
		end
	end
