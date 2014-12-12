class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  skip_before_action :track_user

  def index
  end
end
