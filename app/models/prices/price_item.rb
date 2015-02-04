# == Schema Information
#
# Table name: price_items
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  price          :integer
#  price_group_id :integer
#  lock_version   :integer          default("0"), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Prices::PriceItem < ActiveRecord::Base
  belongs_to :group, class_name: Prices::PriceGroup

  default_value_for :price, 0
end
