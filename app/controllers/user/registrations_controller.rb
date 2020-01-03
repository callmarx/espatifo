class User::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  #before_action :configure_permitted_parameters, only: [:create, :update]

  #def configure_permitted_parameters
  #  update_attrs = [:password, :password_confirmation, :current_password, :role]
  #  devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  #end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
   def create
     Rails.logger.info "DEBUG:: sign_up_params = #{sign_up_params}"
     super
   end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
   def update
    if !(current_user.valid_password? account_update_params[:current_password])
      render json: {error: "invalid authentication"} ,status: :unauthorized
    else
      without_current_password = account_update_params.to_hash
      without_current_password.delete 'current_password'
      current_user.update(without_current_password)
      current_user.save
      super
    end
   end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private
    def respond_with(resource, _opts = {})
      render json: resource
    end
    def respond_to_on_destroy
      head :ok
    end

  protected
  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role, :birthdate])
     #devise_parameter_sanitizer.permit(:sign_up) {|u|
     #  u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :birthdate)
     #}
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:role, :birthdate])
   end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
