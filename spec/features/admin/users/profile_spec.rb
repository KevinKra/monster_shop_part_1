require 'rails_helper'

describe "As an Administrator" do
	describe "When I visit a users show page." do
		before :each do
			@ryan = User.create!(name: "Ryan", street_address: "1256 Lucky st.", city: "Arvada", state: "Co.", zip: 80234, email: "admin@gmail.com", password: "admin", role: 1)
			@alex = User.create!(name: "Alex", street_address: "4534 Rawlston Rd.", city: "Arvada", state: "Co.", zip: 80230, email: "admin_1@gmail.com", password: "admin_1", role: 1)
			@kevin = User.create!(name: "Kevin", street_address: "7865 Cottonwood Dr.", city: "Sherrelwood", state: "Co.", zip: 80221, email: "merchant@gmail.com", password: "merchant", role: 2)
			@sebastian = User.create!(name: "Sebastian", street_address: "0980 Pecos St.", city: "Westminster", state: "Co.", zip: 80233, email: "merchant_1@gmail.com", password: "merchant_1", role: 2)
			@derek = User.create!(name: "Derek", street_address: "9907 Alameda Ave.", city: "Thornton", state: "Co.", zip: 80233, email: "user@gmail.com", password: "user", role: 0)

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ryan)
		end

		it "I can see everything the user can see but I cannot update their information." do

			visit "/admin/users/#{@alex.id}"

			expect(current_path).to eq("/admin/users/#{@alex.id}")

			expect(page).to have_content(@alex.name)
			expect(page).to have_content(@alex.street_address)
			expect(page).to have_content(@alex.city)
			expect(page).to have_content(@alex.state)
			expect(page).to have_content(@alex.zip)
			expect(page).to have_content(@alex.email)
			expect(page).to have_content(@alex.created_at)
			expect(page).to have_content(@alex.role)
			expect(page).not_to have_button("Edit Profile")
		end
	end
end
