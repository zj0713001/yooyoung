class UserService
  include Singleton

  def send_sms_captcha(user)
    sms_captcha = Rails.cache.fetch sms_captcha_key(user), expires_in: 30.minutes do
      Settings.sms_captcha.length.times.map{ Settings.sms_captcha.range.sample }.join
    end
    if Settings.sms_captcha.switch
      NotificationService.instance.send_registration_captcha(user, sms_captcha)
    else
      Rails.logger.info "Sms captcha without send. captcha: #{sms_captcha}"
    end
    true
  end

  def valid_sms_captcha?(user, sms_captcha)
    stored_sms_captcha = Rails.cache.read sms_captcha_key(user)

    stored_sms_captcha == sms_captcha
  end

  def delete_sms_captcha(user)
    Rails.cache.delete sms_captcha_key(user)
  end

  protected

  def sms_captcha_key(user)
    "sms_captcha_#{user.phone}"
  end
end
