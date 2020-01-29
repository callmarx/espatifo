class AdminDashboardController < ApplicationController
  before_action :authenticate_admin_moderator
  before_action :set_undigested_input, only: [
    :show_my_undigested_input, :relate_data_set_undigested_input, :update_undigested_input
  ]


  ## OBS: Por enquanto não estamos trabalhando com chaves ternários no JSONB (content) do
  ## undigest_input, trabalhando direto com as chaves/colunas fornecidas pelo usuário

  # GET /dashboard/undigested_input
  def index_my_undigested_input
    if current_user.admin?
      @undigested_inputs = UndigestedInput.all
    else
      @undigested_inputs = current_user.undigested_inputs
    end
    render json: @undigested_inputs.map{
      |ui| ui.as_json(
        include: { data_set: {except: [:keys_info]}}, except: [:data_set_id, :keys_info]
      ).merge(
        {"total_content" => ui.content.count}
      )
    }, status: :ok
  end

  # GET /dashboard/undigested_input/:id
  def show_my_undigested_input
    render json: @undigested_input.as_json(
      include: { data_set: {except: [:keys_info]}}, except: [:data_set_id, :keys_info]
    ).merge(
      {"total_content" => @undigested_input.content.count}
    ), status: :ok
  end

  # POST /dashboard/undigested_input
  def create_undigested_input
    treated_params = undigested_input_params
    @undigested_input = UndigestedInput.create(
      treated_params.merge({user: current_user})
    )
    unless @undigested_input.valid?
      render json: {undigested_input_error: @undigested_input.errors}, status: :unprocessable_entity
      return
    end
    render json: @undigested_input, status: :created
  end

  # PUT/PATCH /dashboard/undigested_input/:id
  def update_undigested_input
    # no update espera-se não ter mais um data_set no body da requisição
    treated_params = undigested_input_params

    if treated_params[:content]
      treated_params[:content].each do |subject|
        if @undigested_input.content.include? subject
          render json: {
            undigested_input_error: "Duplicated! Some content already exists!"
          }, status: :unprocessable_entity
          return
        end
        @undigested_input.content << subject
      end
    end

    if treated_params[:status]
      if treated_params[:status].is_a? String and
      ["todo", "doing", "done"].include? treated_params[:status]
        @undigested_input.status = treated_params[:status]
      else
        render json: {
          undigested_input_error: "Only allowed 'todo', 'doing' and 'done' for status"
        }, status: :unprocessable_entity
        return
      end
    end

    if treated_params[:data_set_id]
      unless current_user.admin?
        render json: {access_error: "Only admin can link a data_set"}, status: :unauthorized
        return
      end
      @data_set = DataSet.find_by_id treated_params[:data_set_id]
      unless @data_set
        render json: {data_set_error: "data_set do not exist"}, status: :not_found
        return
      end
      @undigested_input.data_set = @data_set
    end

    unless @undigested_input.valid?
      render json: {
        undigested_input_error: @undigested_input.errors
      }, status: :unprocessable_entity
      return
    end
    @undigested_input.save
    render json: @undigested_input, status: :ok
  end


  private
    def set_undigested_input
      if current_user.admin?
        @undigested_input = UndigestedInput.find_by_id(params[:id])
      else
        @undigested_input = current_user.undigested_inputs.find_by_id(params[:id])
      end
      unless @undigested_input
        render json: {
          undigested_input_error: "You don't have this undigested_input"
        }, status: :not_found
        return
      end
    end

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
