class OrdersController <ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def index
    @orders = current_user.orders
    # current_user.orders
  end

  def update
    order = Order.find(params[:id])
    order.update(current_status: 1)
    status_update_unfulfilled(order)
    flash[:notice] = "Your order has been cancelled."
    redirect_to "/profile/orders"
  end

  def create
    order = current_user.orders.create
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
    session.delete(:cart)
    flash[:notice] = "Your order has been created."
    redirect_to '/profile/orders'
  end

  private

  def status_update_unfulfilled(order)
    item_orders = ItemOrder.where(order_id: order.id)
    item_orders.each do |item_order|
      item_order.update(status: 0)
    end
  end
end
