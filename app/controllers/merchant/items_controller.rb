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

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:item]
      update_item_info
    else
      update_active_status
      redirect_to '/merchant/items'
    end
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

  def update_item_info
    @item.update(item_params)
    if @item.save
      flash[:notice] = "Item '#{@item.name}' has been updated."
      redirect_to '/merchant/items'
    else
      flash[:notice] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{@item.id}/edit"
    end
  end

  def update_active_status
    if @item.active?
      @item.update(active?: false)
      flash[:notice] = "Item '#{@item.name}' is no longer for sale."
    else
      @item.update(active?: true)
      flash[:notice] = "Item '#{@item.name}' is now for sale."
    end
  end
end
