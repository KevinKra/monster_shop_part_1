class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @items = merchant.items
    else
      @items = Item.all_active
    end
  end

  def show
    item
  end

  def new
    merchant
  end

  def create
    item = merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    item
  end

  def update
    item.update(item_params)
    if @item.save
      redirect_to "/items/#{item.id}"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

  def merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def item
    @item = Item.find(params[:id])
  end
end
