class NotificationService
  include Singleton

  def send_registration_captcha(user, captcha)
    raise YooYoung::TryTooManyTimesError if Notification.where(notification_type: :send_registration_captcha, channel: :sms, identifier: user.phone, :created_at.gt =>  Time.new.midnight).count >= Settings.sms.sms_limit.to_i

    notification = Notification.new
    content = I18n.t('notification.sms.registration_captcha', captcha: captcha)
    notification.attributes = {
      notification_type: :send_registration_captcha,
      channel: :sms,
      identifier: user.phone,
      content: content,
    }
    notification.save
    SmsWorker.perform_async(notification.id.to_s, user.phone, content)
  end
end
