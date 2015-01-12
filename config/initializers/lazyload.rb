Lazyload::Rails.configure do |config|
  puts ActionController::Base.helpers.asset_path "/assets/blank.gif"
  config.placeholder = ActionController::Base.helpers.asset_url "blank.gif"
end
