class OrdersController < ApplicationController

  def new
  end

  def show
    order
  end

  def index
    @orders = current_user.orders
  end

  def update
    if params[:status] == "ship"
      order.update(current_status: 3)
      redirect_to "/admin/dashboard"
    else
      order.update(current_status: 1)
      status_update_unfulfilled(order)
      flash[:notice] = "Your order has been cancelled."
      redirect_to "/profile/orders"
    end
  end

  def create
    # i dont know why this is here, but removing it breaks a lot of tests i had nothing to do with. If i have time to fix it, i will.
    order = current_user.orders.create(name: '???', address: '123  Ave', city: 'Hershey', state: 'PA', zip: 17033)
    coupon_id = session[:coupon_id]
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.coupon_check(coupon_id)
        })
    end
    session.delete(:cart)
    session.delete(:coupon_id)
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

  def order
    @order = Order.find(params[:id])
  end

end
