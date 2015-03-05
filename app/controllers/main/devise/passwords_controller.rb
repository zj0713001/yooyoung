class Main::Devise::PasswordsController < DeviseController
  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    user = User.find_by(phone: params[:user][:phone])
    if UserService.instance.valid_sms_captcha?(user, params[:sms_captcha])
      success = user.update_attributes params.require(:user).permit(:password, :password_confirmation)
      if success
        UserService.instance.delete_sms_captcha(user)
        sign_in(user, bypass: true)
        delete_user_track_from_session

        respond_to do |format|
          format.json { render json: { status: true, data: user } }
        end
      else
        raise YooYoung::CreateError
      end
    else
      raise YooYoung::IncorrectArguments
    end
  end

  # GET /resource/password/edit
  def edit
    self.resource = current_user
  end

  # PUT /resource/password
  def update
    if !current_user.valid_password?(params[:user][:current_password].to_s)
      flash_message I18n.t('main.users.current_password_error'), type: :error
    else
      if current_user.update_attributes params.require(:user).permit(:password, :password_confirmation)
        sign_in(current_user, bypass: true)
        flash_message I18n.t('main.users.password_change_success')
      else
        flash_message current_user.errors.full_messages.join('，'), type: :error
      end
    end

    respond_to do |format|
      format.html { redirect_to action: :edit }
    end
  end

  protected
  def self.controller_path
    'devise/passwords'
  end
end
