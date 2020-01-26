class AdminDashboardController < ApplicationController
  before_action :authenticate_admin_moderator

  #def teste
  #  render json: undigested_input_params
  #end

  def create_undigested_input
    treated_params = undigested_input_params
    data_set = DataSet.create(treated_params[:data_set].merge(keys_info: {}))
    unless data_set.valid?
      render json: {data_set_error: data_set.errors}, status: :unprocessable_entity
      return
    end
    undigested_input = UndigestedInput.create(
      treated_params.except(:data_set).merge({user: current_user, data_set: data_set})
    )
    unless undigested_input.valid?
      render json: {undigested_input_error: undigested_input.errors}, status: :unprocessable_entity
      return
    end
    render json: undigested_input, status: :created
  end


  private
    def authenticate_admin_moderator
      authenticate_user!
      if !(current_user.admin? or current_user.moderator?)
        render json: {error: "only admin or moderator can access dahsboard"}, status: :unauthorized
      end
    end

    def undigested_input_params
      params.require(:undigested_input).to_unsafe_h
      #treated_params = params.require(:undigested_input).permit(data_set: Hash, content: Hash)
      #treated_params[:data_set].to_unsafe_h
      #treated_params[:content].to_unsafe_h
      #treated_params
    end
end
