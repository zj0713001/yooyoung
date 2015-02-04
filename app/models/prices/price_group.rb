# == Schema Information
#
# Table name: price_groups
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  limit        :integer
#  target_id    :integer
#  target_type  :string(255)
#  lock_version :integer          default("0"), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Prices::PriceGroup < ActiveRecord::Base
  has_many :items, class_name: Prices::PriceItem

  default_value_for :limit, 1

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['price'].blank? }

  before_create :build_item
  def build_item
    self.items.build price: 0
  end
end
