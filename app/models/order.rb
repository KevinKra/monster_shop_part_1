class Order <ApplicationRecord
  # validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  enum current_status: ["pending", "cancelled", "packaged", "shipped"]

  def total_quantity
    item_orders.sum(:quantity)
  end

  def grand_total
    item_orders.sum('price * quantity')
  end

  def user_name
    User.find(user_id).name
  end
end
