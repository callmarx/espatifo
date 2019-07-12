class SessionsController < Devise::SessionsController
  include NestedLoginRender
  respond_to :json

  private
  def respond_to_on_destroy
    head :ok
  end

end
