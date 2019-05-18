class ProjectsController < ApplicationController
  before_action :set_client, only: [:index, :create]
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /clients/:client_id/projects
  def index
    @projects = @client.projects.all

    render json: @projects
  end

  # GET /projects
  def index_all
    @projects = Project.all
    render json: @projects
  end

  # GET /clients/:client_id/projects/1
  def show
    render json: @project
  end

  # POST /clients/:client_id/projects
  def create
    @project = @client.projects.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/:client_id/projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/:client_id/projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:client_id])
    end
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
