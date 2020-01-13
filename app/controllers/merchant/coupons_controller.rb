class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.all
  end

  def new
  end

  def create
    coupon = current_user.merchant.coupons.new(coupon_params)
    if coupon.save
      flash[:success] = "Coupon successfully added"
      redirect_to "/merchant/coupons"
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def coupon_params 
      params.permit(
        :name,
        :code,
        :discount,
        :active
      )
    end
end