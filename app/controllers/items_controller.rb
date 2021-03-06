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
  
  def item
    @item = Item.find(params[:id])
  end
end
