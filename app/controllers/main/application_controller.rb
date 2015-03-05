class Main::ApplicationController < ApplicationController
  layout 'main/application'

  before_action :device_change

  def device_change
    return unless request.get?

    routes = Rails.application.routes.routes

    browser_checker = BrowserChecker.new(request)
    if browser_checker.mobile?
      if !params[:controller].match(/^main\/mobile/) && routes.any?{|route| params[:controller].gsub(/^main/, 'main/mobile') == route.defaults[:controller] && params[:action] == route.defaults[:action]}
        redirect_to "/mobile#{request.fullpath}"
      end
    else
      if params[:controller].match(/^main\/mobile/) && routes.any?{|route| params[:controller].gsub(/^main\/mobile/, 'main') == route.defaults[:controller] && params[:action] == route.defaults[:action]}
        redirect_to request.fullpath.gsub(/^\/mobile/, '')
      end
    end
  end
end
