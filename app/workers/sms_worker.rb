class SmsWorker
  include Sidekiq::Worker

  def perform(notification_id, phone, content)
    success = SmsSender.instance.send_to(phone, content)
    if success
      notification = Notification.find notification_id
      notification.update_attributes success: true, successed_at: Time.now
    end
  end
end
