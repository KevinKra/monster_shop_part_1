class User < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :state, :zip, :email, :password
	attr_accessor :password_confirmation 

	validates :email, uniqueness: true, presence: true
	validates_presence_of :password, require: true

  enum role: ["default", "admin", "merchant"]

	has_secure_password
end
