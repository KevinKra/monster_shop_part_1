class Merchants::DashboardController < ApplicationController

  def show
		@merchant = current_user.merchant
  end
end
