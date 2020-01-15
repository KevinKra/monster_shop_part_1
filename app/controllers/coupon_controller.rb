class CouponController < ApplicationController
  def create
    coupon = Coupon.find_by(code: params[:coupon_code])
    if coupon
      redirect_to "/cart"
      session[:coupon_id] = coupon.id
      flash[:success] = "Coupon #{coupon.code} Added. Checkout or continue shopping."
    else
      redirect_to "/cart"
      flash[:failure] = "Hm, the coupon doesn't seem to exist"
    end
  end
end