class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user

  enum current_status: ["pending", "cancelled", "packaged", "shipped"]

  def total_quantity
    ItemOrder.where(order_id: self.id).sum(:quantity)
  end

  def grand_total
    item_orders.sum('price * quantity')
  end

  def user_name
    User.find(user_id).name
  end

  def merchant_quantity(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum(:quantity)
  end

  def merchant_grand_total(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum('item_orders.price * item_orders.quantity')
  end
end
