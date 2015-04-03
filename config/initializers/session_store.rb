# Be sure to restart your server when you modify this file.
if Rails.env.production?
  Rails.application.config.session_store :redis_store, key: '_yooyoung_session', domain: '.yooyoung.cn'
else
  Rails.application.config.session_store :redis_store, key: '_yooyoung_session'
end
