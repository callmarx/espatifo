class ProjectsController < ApplicationController
  before_action :authenticate_login!
  before_action :set_company, only: [:index, :create]
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /companies/:company_id/projects
  def index
    @projects = @company.projects.all

    render json: @projects
  end

  # GET /projects
  def index_all
    @projects = Project.all
    render json: @projects
  end

  # GET /companies/:company_id/projects/1
  def show
    render json: @project
  end

  # POST /companies/:company_id/projects
  def create
    @project = @company.projects.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:company_id])
    end
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :description)
    end
end
