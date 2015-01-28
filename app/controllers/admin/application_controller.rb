class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
  skip_before_action :track_user
  before_action :authorize_admin

  def index
  end

  helper_method :jsvar
  def jsvar
    gon
  end

  def permited_params
    params.permit!
  end

  protected

  def authorize_admin
    raise CanCan::AccessDenied unless current_user.try(:role).try(:admin?)
  end
end
