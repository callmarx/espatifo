class RegistrationsController < Devise::RegistrationsController
  include NestedLoginRender
  respond_to :json

  def new
    build_resource({})
    self.resource.user = params[:user_type].safe_constantize.new(params[:user_attributes])
    respond_with self.resource
  end

  # def create
  #   # super
  #   render self.resource
  # end

  private
  def respond_to_on_destroy
    head :ok
  end

  def sign_up_params
    allow = [:email, :password, :password_confirmation, :user_type, [user_attributes: [:company_id, :first_name, :second_name, :birthdate, :role]]]
    params.require(resource_name).permit(allow)
  end

end
