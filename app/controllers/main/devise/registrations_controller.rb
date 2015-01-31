class Main::Devise::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if UserService.instance.valid_sms_captcha?(resource, params[:sms_captcha])
      resource_saved = resource.save
      yield resource if block_given?
      if resource_saved
        UserService.instance.delete_sms_captcha(resource)
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          delete_user_track_from_session
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        raise YooYoung::CreateError
      end
    else
      raise YooYoung::IncorrectArguments
    end
  end

  def send_sms_captcha
    @user = User.new(user_params)
    @success = UserService.instance.send_sms_captcha(@user)

    respond_to do |format|
      format.json { render json: { success: @success } }
    end
  end

  def check_phone
    @user = User.find_by_phone(user_params[:phone])
    raise YooYoung::DuplicateCreatedError if @user.present?

    respond_to do |format|
      format.json { render json: { success: @success } }
    end
  end

  private
  def user_params
    params.require(:user).permit(:phone)
  end
end
