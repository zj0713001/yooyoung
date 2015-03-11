class NotificationService
  include Singleton

  def send_registration_captcha(user, captcha)
    content = I18n.t('notification.sms.registration_captcha', captcha: captcha)
    notification = build_notification(
      notification_type: :send_registration_captcha,
      channel: :sms,
      title: :registration_captcha,
      identifier: user.phone,
      content: content,
      verify_limit: true
    )

    SmsJob.perform_later(notification.id.to_s, user.phone, content)
  end

  def send_trade_confirmed_sms(trade)
    content = I18n.t('notification.sms.trade_confirmed', trade_id: trade.to_param, hotel_name: trade.hotel.chinese)
    notification = build_notification(
      notification_type: :send_trade_confirmed_sms,
      channel: :sms,
      title: :trade_confirmed_sms,
      identifier: trade.communicate.phone,
      content: content
    )

    SmsJob.perform_later(notification.id.to_s, trade.communicate.phone, content)
  end

  def send_trade_confirmed_email(trade)
    notification = build_notification(
      notification_type: :send_trade_confirmed_email,
      channel: :email,
      title: :trade_confirmed_email,
      identifier: trade.communicate.email
    )

    TradeMailer.confirmed(trade).deliver_later
  end

  def send_trade_canceled_email(trade)
    notification = build_notification(
      notification_type: :send_trade_canceled_email,
      channel: :email,
      title: :trade_canceled_email,
      identifier: trade.communicate.email
    )

    TradeMailer.canceled(trade).deliver_later
  end

  def send_trade_timeouted_email(trade)
    notification = build_notification(
      notification_type: :send_trade_timeouted_email,
      channel: :email,
      title: :trade_timeouted_email,
      identifier: trade.communicate.email
    )

    TradeMailer.timeouted(trade).deliver_later
  end

  def send_trade_paied_sms(trade)
    content = I18n.t('notification.sms.trade_paied', trade_id: trade.to_param, hotel_name: trade.hotel.chinese)
    notification = build_notification(
      notification_type: :send_trade_paied_sms,
      channel: :sms,
      title: :trade_paied_sms,
      identifier: trade.communicate.phone,
      content: content
    )

    SmsJob.perform_later(notification.id.to_s, trade.communicate.phone, content)
  end

  def send_trade_paied_email(trade)
    notification = build_notification(
      notification_type: :send_trade_paied_email,
      channel: :email,
      title: :trade_paied_email,
      identifier: trade.communicate.email
    )

    TradeMailer.paied(trade).deliver_later
  end

  def send_trade_submitted_email(trade)
    notification = build_notification(
      notification_type: :send_trade_submitted_email,
      channel: :email,
      title: :trade_submitted_email,
      identifier: trade.communicate.email
    )

    TradeMailer.submitted(trade).deliver_later
  end

  def send_trade_rejected_sms(trade)
    content = I18n.t('notification.sms.trade_rejected', trade_id: trade.to_param, hotel_name: trade.hotel.chinese, reject_remark: trade.extra_remark.try(:content) || '无')
    notification = build_notification(
      notification_type: :send_trade_rejected_sms,
      channel: :sms,
      title: :trade_rejected_sms,
      identifier: trade.communicate.phone,
      content: content
    )

    SmsJob.perform_later(notification.id.to_s, trade.communicate.phone, content)
  end

  def send_trade_rejected_email(trade)
    notification = build_notification(
      notification_type: :send_trade_rejected_email,
      channel: :email,
      title: :trade_rejected_email,
      identifier: trade.communicate.email
    )

    TradeMailer.rejected(trade).deliver_later
  end

  def send_trade_register_email(trade)
    notification = build_notification(
      notification_type: :send_trade_register_email,
      channel: :email,
      title: :trade_register_email,
      identifier: trade.communicate.email
    )

    TradeMailer.register(trade).deliver_later
  end

  protected

  def build_notification(notification_type: nil, channel: nil, title: nil, identifier: nil, content: nil, verify_limit: false)
    raise YooYoung::TryTooManyTimesError if verify_limit && Notification.where(notification_type: notification_type, channel: channel, identifier: identifier, :created_at.gt =>  Time.new.midnight).count >= Settings.sms.sms_limit.to_i

    notification = Notification.new
    notification.attributes = {
      notification_type: notification_type,
      channel: channel,
      title: title,
      identifier: identifier,
      content: content,
    }
    notification.save
    notification
  end
end
