class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:id])
    item_order.update(status: 1)
    new_quantity = item_order.item.inventory - item_order.quantity
    item_order.item.update(inventory: new_quantity)
    flash[:notice] = "Item '#{item_order.item.name}' has been fulfilled"
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end
end
