# == Schema Information
#
# Table name: trades
#
#  id                 :integer          not null, primary key
#  total_price        :integer
#  changed_price      :integer
#  preferential_price :integer
#  payment_price      :integer
#  user_id            :integer
#  room_id            :integer
#  hotel_id           :integer
#  package_id         :integer
#  communicate_id     :integer
#  start_day          :date
#  end_day            :date
#  extra_bed_num      :integer
#  child_num          :integer
#  book_email         :string(255)
#  book_cc_email      :string(255)
#  aasm_state         :string(255)
#  lock_version       :integer          default("0"), not null
#  created_at         :datetime
#  updated_at         :datetime
#  people_num         :integer          default("2"), not null
#  trade_no           :string(255)      default(""), not null
#  deleted_at         :datetime
#  cost_price         :integer
#  editor_id          :integer
#

class Trade < ActiveRecord::Base
  include ActiveRecord::SoftDeletable
  include Iron::Condition
  belongs_to :user
  belongs_to :room
  belongs_to :hotel
  belongs_to :package, class: HotelPackage
  belongs_to :communicate, class: Contacts::Communicate
  belongs_to :editor, class_name: User
  has_many :payments
  has_and_belongs_to_many :attendences, uniq: true, class_name: Contacts::Attendence, join_table: :contacts_infos_trades, association_foreign_key: :contacts_info_id

  default_value_for :communicate do
    Contacts::Communicate.new
  end

  accepts_nested_attributes_for :communicate, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :attendences, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['name'].blank? }

  include ActiveRecord::Remarkable
  act_as_remark [:user_remark, :editor_remark, :extra_remark]

  before_create :build_hotel_and_end_day
  def build_hotel_and_end_day
    self.hotel = self.package.hotel
    self.end_day = self.start_day + self.package.days
  end
  before_create :build_prices
  def build_prices
    self.changed_price = self.preferential_price = self.payment_price = self.total_price
  end
  before_create :build_trade_no
  def build_trade_no
    now = Time.now
    self.trade_no = now.to_date.strftime('%Y%m%d') << (now - now.midnight).to_i.to_s.rjust(8, '0')
  end

  scope :last_three_months, ->{ where(created_at: [3.months.ago..Time.now]) }
  scope :paid, ->{ where(aasm_state: %w[sms_valid sms_traveled sms_over_success]) }

  include AASM
  aasm whiny_transitions: false, requires_new_transaction: false do
    state :sms_submitted, initial: true, after_enter: :notification_submitted
    state :sms_confirmed
    state :sms_valid
    state :sms_traveled
    state :sms_over_success
    state :sms_over_drawback_done
    state :sms_over_failure
    state :sms_over_canceled

    event :confirm do
      transitions from: :sms_submitted, to: :sms_confirmed do
        after do
          if self.changed_price_changed?
            self.payment_price = self.changed_price
          end
          TradeTimeoutJob.set(wait: 1.day).perform_later(self.to_param)
          notification_confirmed
        end
      end
    end
    event :reject do
      transitions from: :sms_submitted, to: :sms_over_failure do
        after do
          notification_rejected
        end
      end
    end
    event :cancel do
      transitions from: :sms_submitted, to: :sms_over_canceled do
        after do
          notification_canceled
        end
      end
      transitions from: :sms_confirmed, to: :sms_over_canceled do
        after do
          notification_canceled
        end
      end
      # transitions from: :sms_valid, to: :sms_over_canceled
    end
    event :timeout do
      transitions from: :sms_confirmed, to: :sms_over_failure do
        after do
          notification_timeouted
        end
      end
    end
    event :pay do
      transitions from: :sms_confirmed, to: :sms_valid do
        after do
          notification_paied
        end
      end
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

  def submitted?
    self.sms_submitted?
  end

  def confirmed?
    self.sms_confirmed?
  end

  def successed?
    self.sms_valid? || self.sms_traveled? || self.sms_over_success?
  end

  def failed?
    self.sms_over_failure? || self.sms_over_canceled? || self.sms_over_drawback_done?
  end

  def can_cancel?
    self.sms_valid? || self.sms_confirmed? || self.sms_submitted?
  end

  def price_changed?
    self.total_price != self.changed_price
  end

  def notification_submitted
    NotificationService.instance.send_trade_submitted_email(self)
  end

  def notification_confirmed
    NotificationService.instance.send_trade_confirmed_sms(self)
    NotificationService.instance.send_trade_confirmed_email(self)
  end

  def notification_rejected
    NotificationService.instance.send_trade_rejected_sms(self)
    NotificationService.instance.send_trade_rejected_email(self)
  end

  def notification_canceled
    NotificationService.instance.send_trade_canceled_email(self)
  end

  def notification_timeouted
    NotificationService.instance.send_trade_timeouted_email(self)
  end

  def notification_paied
    NotificationService.instance.send_trade_paied_sms(self)
    NotificationService.instance.send_trade_paied_email(self)
  end

  # for hidden id
  def self.find_by_param(id)
    self.find_by(trade_no: id)
  end

  def to_param
    self.trade_no
  end
end
