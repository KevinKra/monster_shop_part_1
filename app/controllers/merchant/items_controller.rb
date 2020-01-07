class Merchant::ItemsController < ApplicationController
  before_action :require_merchant_access

  def index
    @items = Item.where(merchant_id: current_user.merchant.id)
  end

  def update
    @item = Item.find(params[:item_id])
    @item.update(active?: false)
    flash[:notice] = "Item '#{@item.name}' is no longer for sale."
    redirect_to '/merchant/items'
  end

  private

  def require_merchant_access
    render file: "/public/404" unless current_merchant?
  end
end
