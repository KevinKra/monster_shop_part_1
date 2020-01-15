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

  def edit
    # permission denied???
    coupon = Coupon.find_by(id: params[:id])
  end

  def update

  end

  def destroy
    coupon = Coupon.find_by(id: params[:id])
    if coupon.not_in_use?
      coupon.destroy
      redirect_to "/merchant/coupons"
      flash[:success] = "Coupon successfully deleted"
    elsif !coupon.not_in_use? 
      redirect_to "/merchant/coupons/#{params[:id]}"
      flash[:failure] = "Coupon is currently being used in an order"
    else
      redirect_to "/merchant/coupons/#{params[:id]}"
      flash[:failure] = "Coupon could not be found"
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