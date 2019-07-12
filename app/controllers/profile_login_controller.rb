class ProfileLoginController < ApplicationController
  include NestedLoginRender
  before_action :authenticate_login!

    # PUT /profile/edit
    def edit
      @login = current_login
      if @login.user.update(update_params)
      # Sign in the user by passing validation in case their password changed
        respond_with @login
      else
        render json: {error: "coundn't edit", log: @login.errors}
      end
    end


    # PUT /profile/changepassword
    def update_password
      @login = current_login
      if @login.update_with_password(change_pass_params)
        respond_with @login
      else
        render json: {error: "coundn't edit", log: @login.errors}
      end
    end

    private
    # def respond_with(resource, _opts = {})
    #   result = resource.as_json
    #   result["user_attributes:"] = resource.user.as_json.except("id")
    #   if result["user_attributes:"].has_key? "company_id"
    #     result["user_attributes:"]["company__attributes"] = resource.user.company
    #   end
    #   render json: result
    # end

    def change_pass_params
      # NOTE: Using `strong_parameters` gem
      params.require(:login).permit(:current_password, :password, :password_confirmation)
    end

    def update_params
      params.require(:user_attributes).permit(:first_name, :second_name, :birthdate, :role)
    end
  end
