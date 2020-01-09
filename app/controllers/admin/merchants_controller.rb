class Admin::MerchantsController < ApplicationController

	def index
		@merchants = Merchant.all
	end

	def edit
    @merchant = Merchant.find(params[:id])
  end

	def update
		@merchant = Merchant.find(params[:id])
		if @merchant.able?
			@merchant.update(able?: false)
			flash[:notice] = "Merchant '#{@merchant.name}' is no longer active."
			redirect_to "/admin/merchants"
		else
			@merchant.update(able?: true)
			flash[:notice] = "Merchant '#{@merchant.name}' is now active."
			redirect_to "/admin/merchants"
		end
	end
end
