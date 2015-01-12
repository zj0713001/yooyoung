Lazyload::Rails.configure do |config|
  config.placeholder = ActionController::Base.helpers.asset_url "blank.gif"
end
