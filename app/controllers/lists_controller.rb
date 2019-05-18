class ListsController < ApplicationController
  before_action :set_project, only: [:index, :create]
  before_action :set_list, only: [:show, :update, :destroy, :preset]

  # GET /clients/:client_id/projects/:project_id/lists
  def index
    @lists = @project.lists.all

    render json: @lists
  end

  # GET /clients/:client_id/projects/:project_id/lists/1
  def show
    render json: @list
  end

  # POST /clients/:client_id/projects/:project_id/lists
  def create
    @list = @project.lists.new(list_params)

    if @list.save
      render json: @list, status: :created, location: @list #ver se esse location funciona
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/:client_id/projects/:project_id/lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/:client_id/projects/:project_id/lists/1
  def destroy
    @list.destroy
  end

  # POST /clients/:client_id/projects/:project_id/lists/1
  def preset
    #fazer as filtragens e buscas na HASH
    teste = preset_params # result = Modulo.execute_preset(@list, preset_params)
    render json: teste
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_list
      @list = List.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def list_params
      params.require(:list).permit(:nosql_hash)
    end

    def preset_params
      params.require(:preset)
    end
end
