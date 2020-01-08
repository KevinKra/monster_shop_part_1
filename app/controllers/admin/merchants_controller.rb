class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    if merchant.disabled?
      merchant.update!(disabled: false)
      redirect_to "/admin/merchants"
      flash[:success] = "#{merchant.name} is now Enabled." 
    else
      merchant.update!(disabled: true)
      redirect_to "/admin/merchants"
      flash[:success] = "#{merchant.name} is now Disabled."
    end
  end
end