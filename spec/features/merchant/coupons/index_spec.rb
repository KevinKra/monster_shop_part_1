require 'rails_helper';

RSpec.describe "merchant/coupons #index" do
  let!(:merchant_user) { create(:user, :merchant_user) }
  let!(:merchant) { create(:merchant) }
  before {
    @coupon_1 = Coupon.create(
      name: "Christmas Special",
      code: "533E21",
      active: true,
      discount: 25,
      merchant: merchant
    )
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_user)
    visit "/merchant/coupons"
  }

  context "page structure" do

    it "should show all current coupons belonging to the merchant" do
      within("#coupon-#{@coupon_1.id}") do
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.code)
        expect(page).to have_content(@coupon_1.active)
        expect(page).to have_content(@coupon_1.discount)
      end
    end

    it "merchant user is able to delete cards" do
      save_and_open_page
      within("#coupon-#{@coupon_1.id}") do
        expect(page).to have_link("delete", href: "merchant/coupons/:id")
      end
    end
  end

end