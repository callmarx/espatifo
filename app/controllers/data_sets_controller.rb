class DataSetsController < ApplicationController
  include Pagy::Backend
  include ControllerDataResolve
  #before_action :authenticate_user!
  before_action :set_data_set, only: [:show]
  before_action :set_dynamic_content, only: [:list]
  before_action :set_paginate_params, only: [:list]

  # GET /data_sets
  def index
    @data_sets = DataSet.order('id ASC')
    render json: @data_sets, except: [:keys_info]
  end

  # GET /data_sets/1
  def show
    render json: @data_set, except: [:keys_info]
  end

  # POST /data_sets/1
  def show_more
    
  end

  # POST /data_sets/1/list
  def list
    @pagy, @list_paginated = pagy(@dynamic_content.order(order_query), items: @per_page)
    relation_decode
    render json: {
      total_listed: @total_listed,
      total_pages: @pagy.pages,
      current_page: @page_selected,
      per_page: @per_page,
      result: @list_decoded
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      @data_set = DataSet.find(params[:id])
    end

    def set_dynamic_content
      set_data_set
      @dynamic_content = @data_set.dynamic_content
      @total_listed = @dynamic_content.count
    end

    # parametros de url para paginação
    def set_paginate_params
      @page_selected = params[:page] || 1
      @per_page = params[:per_page] || 30
    end
end
