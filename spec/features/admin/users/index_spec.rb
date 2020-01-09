require 'rails_helper'

describe 'As an Administrator' do
	describe 'When I visit the users index page' do
		before :each do
			@ryan = User.create!(name: "Ryan", street_address: "1256 Lucky st.", city: "Arvada", state: "Co.", zip: 80234, email: "admin@gmail.com", password: "admin", role: 1)
			@alex = User.create!(name: "Alex", street_address: "4534 Rawlston Rd.", city: "Arvada", state: "Co.", zip: 80230, email: "admin_1@gmail.com", password: "admin_1", role: 1)
			@kevin = User.create!(name: "Kevin", street_address: "7865 Cottonwood Dr.", city: "Sherrelwood", state: "Co.", zip: 80221, email: "merchant@gmail.com", password: "merchant", role: 2)
			@sebastian = User.create!(name: "Sebastian", street_address: "0980 Pecos St.", city: "Westminster", state: "Co.", zip: 80233, email: "merchant_1@gmail.com", password: "merchant_1", role: 2)
			@derek = User.create!(name: "Derek", street_address: "9907 Alameda Ave.", city: "Thornton", state: "Co.", zip: 80233, email: "user@gmail.com", password: "user", role: 0)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ryan)
		end

		it 'I see all the users name, registration date and user type' do

			visit "/admin/users"

			expect(current_path).to eq("/admin/users")

			expect(page).to have_content(@alex.name)
			expect(page).to have_content(@alex.created_at)
			expect(page).to have_content(@alex.role)
			expect(page).to have_content(@kevin.name)
			expect(page).to have_content(@kevin.created_at)
			expect(page).to have_content(@kevin.role)
			expect(page).to have_content(@sebastian.name)
			expect(page).to have_content(@sebastian.created_at)
			expect(page).to have_content(@sebastian.role)
			expect(page).to have_content(@derek.name)
			expect(page).to have_content(@derek.created_at)
			expect(page).to have_content(@derek.role)
		end
	end
end
