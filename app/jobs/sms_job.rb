class SmsJob < ActiveJob::Base
  queue_as :smses

  def perform(notification_id, phone, content)
    success = if Settings.sms.switch
      SmsSender.instance.send_to(phone, content)
    else
      Rails.logger.info "Sms without send. Notification: #{notification_id}. Phone: #{phone}. Content: #{content}."
      true
    end
    if success
      notification = Notification.find notification_id
      notification.update_attributes success: true, successed_at: Time.now
    end
  end
end
