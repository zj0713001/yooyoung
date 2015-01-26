class SmsSender
  include Singleton

  def initialize
    ChinaSMS.use :smsbao, username: Settings.sms.username, password: Settings.sms.password
  end

  def send_to(phone, content)
    raise 'content empty!' unless content.present?

    raise 'phone number error!' if Array(phone).any?{|p| p.match(TotalRegexp.phone).blank? }

    content << '【悠漾旅行】'
    response = Timeout::timeout(30) { ChinaSMS.to phone, content }
    return false unless response.try(:[], :success)
    true
  end
end
