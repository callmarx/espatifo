class ListsController < ApplicationController
  require 'will_paginate/array'
  include Listable
  # before_action :authenticate_login!
  before_action :set_project, only: [:index, :create]
  before_action :set_list, only: [:show, :csv_index, :graph_data, :preset, :update, :destroy]
  before_action :set_paginate_params, only: [:show, :csv_index, :graph_data, :preset]

  # GET /companies/:company_id/projects/:project_id/lists
  def index
    @lists = @project.lists.all

    render json: @lists
  end

  # GET /lists/1
  def show
    list_paginated = @list.csv_json.paginate(page: @page_selected, per_page: @per_page)
    render json: {list_id: @list.id, total_listed: @list.csv_json.count, total_pages: list_paginated.total_pages, current_page: @page_selected, per_page: @per_page, hashes: list_paginated}
  end

  # GET /lists/1/csv_index/<index>
  def csv_index
    one_hash = @list.csv_json[params[:index] == nil ? 0 : params[:index].to_i - 1]
    render json: one_hash
  end

  # POST /lists/1/preset
  def preset
    filtered = get_preset(preset_params)
    result = filtered.paginate(page: @page_selected, per_page: @per_page)
    render json: {list_id: @list.id, total_listed: filtered.count, total_pages: result.total_pages, current_page: @page_selected, per_page: @per_page, hashes: result}
  end

  # post /lists/1/graph_data
  def graph_data
    final_result = get_graph_data(preset_params)
    render json: final_result
  end

  # POST /companies/:company_id/projects/:project_id/lists
  def create
    @list = @project.lists.new(list_params)

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lists/1
  def destroy
    @list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_list
      @list = Rails.cache.fetch([List,params[:id], __method__], expires_in: 30.minutes) do
        List.find(params[:id])
      end
    end

    def set_paginate_params
      @page_selected = params[:page] || 1
      @per_page = params[:per_page] || 30
    end

    # Only allow a trusted parameter "white list" through.
    def list_params
      params.require(:list).permit(:csv_json)
    end
    def preset_params
      params.require(:preset)
    end
end
