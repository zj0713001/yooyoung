class Trade < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :hotel
  belongs_to :package, class: HotelPackage
  belongs_to :communicate, class: Contacts::Communicate
  has_many :payments
  has_and_belongs_to_many :attendences, uniq: true, class_name: Contacts::Attendence

  accepts_nested_attributes_for :communicate, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :attendences, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }

  include ActiveRecord::Remarkable
  act_as_remark :user_remark, :editor_remark

  include AASM
  aasm whiny_transitions: false, requires_new_transaction: false do
    state :sms_submitted, initial: true
    state :sms_confirmed
    state :sms_valid
    state :sms_traveled
    state :sms_over_success
    state :sms_over_drawback_done
    state :sms_over_failure
    state :sms_over_canceled

    event :confirm do
      transitions from: :sms_submitted, to: :sms_confirmed
    end
    event :refuse do
      transitions from: :sms_submitted, to: :sms_over_failure
    end
    event :cancel do
      transitions from: :sms_submitted, to: :sms_over_canceled
      transitions from: :sms_valid, to: :sms_over_canceled
    end
    event :pay do
      transitions from: :sms_confirmed, to: :sms_valid
    end
    event :travel do
      transitions from: :sms_valid, to: :sms_traveled
    end
    event :done do
      transitions from: :sms_traveled, to: :sms_over_success
    end
    event :drawback do
      transitions from: :sms_valid, to: :sms_over_drawback_done
    end
  end
end
