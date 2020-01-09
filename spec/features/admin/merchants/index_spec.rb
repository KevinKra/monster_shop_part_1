require 'rails_helper'

describe 'As an admin' do
	describe 'when I visit the merchants index page' do
		before :each do
			@ryan = User.create!(name: "Ryan", street_address: "1256 Lucky st.", city: "Arvada", state: "Co.", zip: 80234, email: "admin@gmail.com", password: "admin", role: 1)
			@megs_bikes = Merchant.create!(name:"Meg's Bike Shop", address:"1234 Fake st.", city: "Denver", state: "Co.", zip:80230)
			@mikes_tatoos = Merchant.create!(name:"Mike's Tatoos", address:"9088 Fake st.", city: "Denver", state: "Co.", zip:80230)
			@sals_salads = Merchant.create!(name:"Sal's Salads", address:"7856 Fake st.", city: "Denver", state: "Co.", zip:80230)
			@megs_bikes.users << [@ryan]
			@mikes_tatoos.users << [@ryan]
			@sals_salads.users << [@ryan]

			allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@ryan)
		end

		it 'I see a list of all the merchants name, city and state' do

			visit "/admin/merchants"

			expect(current_path).to eq("/admin/merchants")

			expect(page).to have_content(@megs_bikes.name)
			expect(page).to have_content(@megs_bikes.city)
			expect(page).to have_content(@megs_bikes.state)
			expect(page).to have_content(@mikes_tatoos.name)
			expect(page).to have_content(@mikes_tatoos.city)
			expect(page).to have_content(@mikes_tatoos.state)
			expect(page).to have_content(@sals_salads.name)
			expect(page).to have_content(@sals_salads.city)
			expect(page).to have_content(@sals_salads.state)
		end

		it "There is a disable button next to all enabled merchants." do

		visit "/admin/merchants"

		expect(current_path).to eq("/admin/merchants")

		expect(page).to have_button("Disable")

		within "#merchant-#{@mikes_tatoos.id}" do
			click_on "Disable"
		end

		expect(current_path).to eq("/admin/merchants")
		within "#main-flash" do
			expect(page).to have_content("Merchant '#{@mikes_tatoos.name}' is no longer active.")
		end

		within "#merchant-#{@mikes_tatoos.id}" do
			expect(page).to have_button("Enable")
			expect(page).not_to have_button("Disable")
			end
		end

		it "There is a enable button next to all disabled merchants." do

			visit "/admin/merchants"

			expect(current_path).to eq("/admin/merchants")

			expect(page).to have_button("Disable")

			within "#merchant-#{@mikes_tatoos.id}" do
				click_on "Disable"
			end

			expect(current_path).to eq("/admin/merchants")
			within "#main-flash" do
				expect(page).to have_content("Merchant '#{@mikes_tatoos.name}' is no longer active.")
			end

			within "#merchant-#{@mikes_tatoos.id}" do
				expect(page).to have_button("Enable")
				expect(page).not_to have_button("Disable")
				end

			expect(current_path).to eq("/admin/merchants")

			expect(page).to have_button("Enable")

			within "#merchant-#{@mikes_tatoos.id}" do
				click_on "Enable"
			end

			expect(current_path).to eq("/admin/merchants")
			within "#main-flash" do
				expect(page).to_not have_content("Merchant '#{@mikes_tatoos.name}' is no longer active.")
				expect(page).to have_content("Merchant '#{@mikes_tatoos.name}' is now active.")
			end

			within "#merchant-#{@mikes_tatoos.id}" do
				expect(page).to_not have_button("Enable")
				expect(page).to have_button("Disable")
			end
		end
	end
end
