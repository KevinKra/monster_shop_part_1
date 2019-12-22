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

  def create
    order = current_user.orders.create
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to '/profile/orders'
    else
      flash[:notice] = "Something went wrong"
    end
  end
end
