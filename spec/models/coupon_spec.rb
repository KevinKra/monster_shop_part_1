require 'rails_helper';

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
    it { should validate_inclusion_of(:discount).in_range(0..100)}
  end

  describe "uniqueness" do
    it { should validate_uniqueness_of :code }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end
end