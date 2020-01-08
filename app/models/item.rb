class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.all_active
    Item.where(active?: :true)
  end

  def self.top_five_bought
    joins(:item_orders)
    .select('items.* sum, sum(item_orders.quantity) as quantity')
    .group(:id)
    .order('quantity desc')
    .limit(5).to_a
  end

  def self.bottom_five_bought
    joins(:item_orders)
    .select('items.* sum, sum(item_orders.quantity) as quantity')
    .group(:id)
    .order('quantity')
    .limit(5).to_a
  end

  def quantity_bought
    ItemOrder.where(item_id: self.id).sum(:quantity)
  end

  def order_count(order_id)
    ItemOrder.where(item_id: self.id, order_id: order_id).sum(:quantity)
  end

  def order_subtotal(order_id)
    unit_price = ItemOrder.where(item_id: self.id, order_id: order_id).sum(:price)
    unit_price * order_count(order_id)
  end
end
