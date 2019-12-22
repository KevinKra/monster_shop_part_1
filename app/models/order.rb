class Order <ApplicationRecord
  # validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  enum current_status: ["pending"]
  # def grandtotal
  #   item_orders.sum('price * quantity')
  # end
end
