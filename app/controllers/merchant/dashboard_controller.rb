class Merchant::DashboardController < Merchant::BaseController

  def show
    merchant = Merchant.find(current_user.merchant.id)
    @orders = merchant.orders.all.distinct
  end
end
