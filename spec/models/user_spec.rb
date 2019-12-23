require 'rails_helper'

RSpec.describe User, type: :model do
	let!(:user) { create(:user, :default_user) }

	describe 'validations' do
		it {should validate_presence_of :name}
		it {should validate_presence_of :street_address}
		it {should validate_presence_of :city}
		it {should validate_presence_of :state}
		it {should validate_presence_of :zip}
		it {should validate_presence_of :email}
		it {should validate_presence_of :password}

		it {should validate_uniqueness_of :email}
	end

	describe 'relationships' do
		it {should have_many :orders}
	end

	describe 'instance methods' do
		it "returns if a user has an order" do
			expect(user.has_orders?).not_to eq(true)

			user.orders.create

			expect(user.has_orders?).to eq(true)
		end
	end

	describe "roles" do
		it "can be created as an admin" do
				user = User.create(
					name: "Chandler",
					street_address: "123 Five Street",
					city: "Denver",
					state: "CO",
					zip: "80210",
					email: "fake@gmail.com",
					password: "wordpass",
					role: 1
				)

			expect(user.role).to eq("admin")
			expect(user.admin?).to be_truthy
		end

		it "can be created as a default user" do
			user = User.create(
				name: "Chandler",
				street_address: "123 Five Street",
				city: "Denver",
				state: "CO",
				zip: "80210",
				email: "fake@gmail.com",
				password: "wordpass",
				role: 0
			)

			expect(user.role).to eq("default")
			expect(user.default?).to be_truthy
		end

		it "can be created as a merchant user" do
			user = User.create(
				name: "Ross",
				street_address: "123 Five Street",
				city: "Denver",
				state: "CO",
				zip: "80210",
				email: "fake@gmail.com",
				password: "wordpass",
				role: 2
			)

			expect(user.role).to eq("merchant")
			expect(user.merchant?).to be_truthy
		end
	end
end
