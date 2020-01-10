class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.disabled?
      update_merchant_enable
    else
      update_merchant_disable
    end
  end

  private

  def update_merchant_enable
    @merchant.update!(disabled: false)
    redirect_to "/admin/merchants"
    flash[:success] = "#{@merchant.name} is now Enabled."
    @merchant.items.each do |item|
      item.update(active?: true)
    end
  end

  def update_merchant_disable
    @merchant.update!(disabled: true)
    redirect_to "/admin/merchants"
    flash[:success] = "#{@merchant.name} is now Disabled."
    @merchant.items.each do |item|
      item.update(active?: false)
    end
  end
end
