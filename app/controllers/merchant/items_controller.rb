class Merchant::ItemsController < Merchant::BaseController
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
    item
  end

  def update
    item #helper method at the bottom, needs this here to function, could set to a variable if we want.
    if params[:item]
      update_item_info
    else
      update_active_status
      redirect_to '/merchant/items'
    end
  end

  def destroy
    item = Item.find(params[:id]) #the helper method does not work here and I do not know why
    item.destroy
    flash[:notice] = "Item '#{item.name}' has been deleted.'"
    redirect_to "/merchant/items"
  end

  private

  def require_merchant_access
    render file: "/public/404" unless current_merchant?
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

  def item_params
    params.require(:item).permit(:name, :description, :price, :image, :inventory)   #moved into private
  end

  def item
    @item = Item.find(params[:id])
  end

end
