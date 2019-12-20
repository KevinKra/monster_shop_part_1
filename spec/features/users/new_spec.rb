require "rails_helper"

describe 'new user' do
	it 'I should be able to register as a new user' do

		visit '/'

		click_link 'Register as a User'

		expect(current_path).to eq("/register")

		name = "Ryan Allen"
		street_address = "45433 fake st."
		city = "Denver"
		state = "Colorado"
		zip = 80234
		email = "ryan@fake.com"
		password = "BestFakerEver"
		password_confirmation = "BestFakerEver"

		fill_in :name, with: name
		fill_in :street_address, with: street_address
		fill_in :city, with: city
		fill_in :state, with: state
		fill_in :zip, with: zip
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation

		click_on 'Create User'

		expect(current_path).to eq('/profile')

		within('.success-flash') do
			expect(page).to have_content("Welcome, Ryan Allen")
		end
	end

	it 'I should not be able register if form is incomplete' do
		visit '/'

		click_link 'Register as a User'

		name = "Ryan Allen"
		street_address = "45433 fake st."
		city = "Denver"
		state = "Colorado"
		zip = 80234
		email = "ryan@fake.com"
		password = "BestFakerEver"
		password_confirmation = "BestFakerEver"

		fill_in :name, with: name
		fill_in :street_address, with: street_address
		fill_in :zip, with: zip
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation

		click_on 'Create User'

		expect(current_path).to eq('/register')

		within('.error-flash') do
			expect(page).to have_content("City can't be blank")
			expect(page).to have_content("State can't be blank")
		end
	end

	it 'I should not be able register if password and password confirmation do not match' do
		visit '/'

		click_link 'Register as a User'

		name = "Ryan Allen"
		street_address = "45433 fake st."
		city = "Denver"
		state = "Colorado"
		zip = 80234
		email = "ryan@fake.com"
		password = "BestFakerEver"
		password_confirmation = "BestFakerNever"

		fill_in :name, with: name
		fill_in :street_address, with: street_address
		fill_in :zip, with: zip
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation

		click_on 'Create User'

		expect(current_path).to eq('/register')

		within('.error-flash') do
			expect(page).to have_content("Password confirmation doesn't match Password")
		end
	end

	it 'I should not be able to register with an email that is already used' do
		visit '/'

		click_link 'Register as a User'

		expect(current_path).to eq("/register")

		user_2 = User.create!(
			name: "Mr. Not Ryan",
			street_address: "45433 fake st.",
			city: "Denver",
			state: "Colorado",
			zip: 80234,
			email: "ryan@fake.com",
			password: "password1",
			password_confirmation: "password1"
		)

		name = "Ryan Allen"
		street_address = "45433 fake st."
		city = "Denver"
		state = "Colorado"
		zip = 80234
		email = "ryan@fake.com"
		password = "BestFakerEver"
		password_confirmation = "BestFakerEver"

		fill_in :name, with: name
		fill_in :street_address, with: street_address
		fill_in :city, with: city
		fill_in :state, with: state
		fill_in :zip, with: zip
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation

		click_on 'Create User'

		expect(current_path).to eq('/register')

		within('.error-flash') do
			expect(page).to have_content("Email has already been taken")
		end

		# refactor with specific testing for forms
		expect(page).not_to have_content(email)
	end
end
