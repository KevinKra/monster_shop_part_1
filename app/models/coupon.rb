class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :active

  # name is supposed to be unique "across the whole database", but i dont understand why
  validates :active, presence: true, :inclusion => { :in => [true, false] }
  validates :discount, presence: true, :inclusion => { :in => 0..100 }

  validates_uniqueness_of :code

  belongs_to :merchant
  has_many :orders
end