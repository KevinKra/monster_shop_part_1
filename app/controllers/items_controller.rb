class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all_active
    end
  end

  def show
    item
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def item
    @item = Item.find(params[:id])
  end
end
