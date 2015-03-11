class ApplicationMailer < ActionMailer::Base
  self.asset_host = nil
  include Roadie::Rails::Automatic
end
