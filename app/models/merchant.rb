class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
	has_many :users

  has_many :orders, through: :item_orders
  has_many :coupons, dependent: :destroy


  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
    
  validates :disabled,  :inclusion => { :in => [true, false] }

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end


end
