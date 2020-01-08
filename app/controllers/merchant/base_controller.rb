class Merchant::BaseController < ApplicationController
  before_action :require_merchant_access

  private

  def require_merchant_access
    render file: "/public/404" unless current_merchant?
  end
end
