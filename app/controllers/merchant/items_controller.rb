class Merchant::ItemsController < ApplicationController
  before_action :require_merchant_access

  def index
    @items = Item.where(merchant_id: current_user.merchant.id)
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.merchant.items.new(item_params)
    if @item.save
      flash[:notice] = "Item '#{@item.name}' is now for sale."
      redirect_to '/merchant/items'
    else
      flash[:warning] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.active?
      @item.update(active?: false)
      flash[:notice] = "Item '#{@item.name}' is no longer for sale."
    else
      @item.update(active?: true)
      flash[:notice] = "Item '#{@item.name}' is now for sale."
    end
    redirect_to '/merchant/items'
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:notice] = "Item '#{item.name}' has been deleted.'"
    redirect_to "/merchant/items"
  end

  private

  def require_merchant_access
    render file: "/public/404" unless current_merchant?
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :image, :inventory)
  end
end
