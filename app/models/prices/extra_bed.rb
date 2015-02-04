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

class Prices::ExtraBed < Prices::PriceGroup
  belongs_to :target, polymorphic: true, class_name: Room

  default_value_for :name, '加床价格'
end
