class TradeMailer < ApplicationMailer
  layout 'main/mailer'
  default from: "#{Settings.yooyoung.name} <#{Settings.mailer.from}>"
  default bcc: Settings.mailer.bcc

  def submitted(trade)
    @trade = trade
    @subject = I18n.t('notification.email.submitted.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end

  def confirmed(trade)
    @trade = trade
    @subject = I18n.t('notification.email.confirmed.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end

  def rejected(trade)
    @trade = trade
    @subject = I18n.t('notification.email.rejected.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end

  def canceled(trade)
    @trade = trade
    @subject = I18n.t('notification.email.canceled.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end

  def timeouted(trade)
    @trade = trade
    @subject = I18n.t('notification.email.timeouted.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end

  def paied(trade)
    @trade = trade
    @subject = I18n.t('notification.email.paied.subject', trade_id: @trade.to_param, hotel_name: @trade.hotel.chinese)
    mail(to: @trade.communicate.email, subject: @subject)
  end
end
