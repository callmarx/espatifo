class ListsController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_project, only: [:index, :create]
  before_action :set_list, only: [:show, :update, :destroy, :preset]
  # GET /companies/:company_id/projects/:project_id/lists
  def index
    @lists = @project.lists.all

    render json: @lists
  end

  # GET lists/1
  def show
    require 'will_paginate/array'
    @hashes = @list.csv_json.paginate(page: params[:page], per_page: 30)
    result = {list_id: @list.id, pages: @hashes.total_pages, hashes: @hashes}
    render json: result
    # render json: @jsons
    # result = resource.as_json
    # result["perk_type"] = resource.perk.class.to_s
    # render json: result
  end

  # POST /companies/:company_id/projects/:project_id/lists
  def create
    @list = @project.lists.new(list_params)

    if @list.save
      render json: @list, status: :created, location: @list #ver se esse location funciona
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

  # POST /lists/1/preset
  def preset
    #fazer as filtragens e buscas na HASH
    # require 'will_paginate/array'
    # # cache_key = @list.id
    # Rails.cache.fetch([@list.cache_key, __method__], expires_in: 30.minutes) do
    #   @hashes_filtered = @list.csv_json
    #   preset_params.each { |key, value|
    #     if value.class == Array
    #       begin
    #         data1 = Time.strptime(value[0], '%m/%d/%Y')
    #         data2 = Time.strptime(value[1], '%m/%d/%Y')
    #         @hashes_filtered = @hashes_filtered.select { |h| Time.strptime(h[key], '%m/%d/%Y') >= data1 && Time.strptime(h[key], '%m/%d/%Y') <= data2}
    #       rescue StandardError => e
    #         float1 = value[0].to_f
    #         float2 = value[1].to_f
    #         @hashes_filtered = @hashes_filtered.select { |h| h[key].to_f >= float1 && h[key].to_f <= float2}
    #       end
    #     else
    #       @hashes_filtered = @hashes_filtered.select { |h| h[key] == value}
    #     end
    #   }
    #   # result = Modulo.execute_preset(@list, preset_params)
    #   filtered = @hashes_filtered.paginate(page: params[:page], per_page: 30)
    #   result = {pages: filtered.total_pages, filtered: filtered}
    #   render json: result
    #   # teste = preset_params # result = Modulo.execute_preset(@list, preset_params)
    #   # render json: teste
    # end
    filtered = @list.preset(preset_params)
    require 'will_paginate/array'
    result = filtered.paginate(page: params[:page], per_page: 30)
    render json: {pages: result.total_pages, filtered: result}
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
      params.require(:list).permit(:csv_json)
    end

    def preset_params
      params.require(:preset)
    end
end
