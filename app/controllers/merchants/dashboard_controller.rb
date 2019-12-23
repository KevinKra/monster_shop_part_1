class Merchants::DashboardController < Merchants::BaseController

  def show
		@merchant = current_user.merchant
  end
end
