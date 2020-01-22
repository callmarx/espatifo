class DataSetsController < ApplicationController
  include Pagy::Backend
  include DataResolveConcern
  before_action :authenticate_user!
  before_action :set_data_set, only: [:show]
  before_action :set_dynamic_content, only: [:list, :show_subject, :stats, :show]
  before_action :set_paginate_params, only: [:list]
  before_action :list_params, only: [:list]
  before_action :stats_params, only: [:stats]
  after_action :clean_variables

  # GET /data_sets
  def index
    @data_sets = DataSet.order('id ASC')
    render json: @data_sets.map{|dt|
      dt.as_json.except("keys_info").merge({"enriched" => !(dt.keys_info == {})})
    }
  end

  # GET /data_sets/1
  def show
    render json: @data_set.as_json.except("keys_info").merge(
      {"total_listed" => @dynamic_content.count},
      {"total_keys" => @data_set.keys_info.values}
    ) 
  end

  # GET /data_sets/1/1
  def show_subject
    subject = @dynamic_content.find_by_id(params[:subject_id])
    if subject
      @list_collection = [subject]
      relation_decode
      render json: @list_decoded
    else
      render status: :not_found
    end
  end

  # POST /data_sets/1/list
  def list
    ## BODY parametros:
    # preset
    if params[:preset]
      build_preset_params
      if !@preset_readed.first
        render json: @preset_readed.last, status: :bad_request
        return
      else
        @pagy, @list_collection = pagy(
          @dynamic_content.where(Arel.sql(@preset_readed.last)).order(order_query),
          items: @per_page
        )
      end
    else
      @pagy, @list_collection = pagy(@dynamic_content.order(order_query), items: @per_page)
    end
    relation_decode
    render json: {
      total_listed: @pagy.count,
      total_pages: @pagy.pages,
      current_page: @page_selected,
      per_page: @per_page,
      result: @list_decoded
    }
  end

  # POST /data_sets/1/stats
  def stats
    ## BODY parametros:
    # preset
    # data_chart
    # average
    # min_max
    # sum
    # unique
    # total_keys
    # total_listed

    result = {}
    if params[:preset]
      build_preset_params
      if !@preset_readed.first
        render json: @preset_readed.last, status: :bad_request
        return
      else
        @list_collection = @dynamic_content.where(Arel.sql(@preset_readed.last))
      end
    else
      @list_collection = @dynamic_content.all
    end
    if params[:data_chart]
      result[:data_chart] = get_chart(params[:data_chart])
    end
    if params[:average]
      result[:average] = get_average(params[:average])
    end
    if params[:min_max]
      result[:min_max] = get_min_max(params[:min_max])
    end
    if params[:sum]
      result[:sum] = get_sum(params[:sum])
    end
    if params[:unique_values]
      result[:unique_values] = get_unique_values(params[:unique_values])
    end
    if params[:total_listed] == true
      result[:total_listed] = @list_collection.count
    end
    if params[:total_keys] == true
      result[:total_keys] = @data_set.keys_info.values
    end
    render json: result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      @data_set = DataSet.find_by_id(params[:id])
    end

    def set_dynamic_content
      set_data_set
      @dynamic_content = @data_set.dynamic_content
    end

    # parametros de url para paginação
    def set_paginate_params
      @page_selected = params[:page] || 1
      @per_page = params[:per_page] || 30
    end

    def list_params
      ### REFATORAR!!!
      ### não adianta por conta do to_unsafe_h
      params.permit(:preset)
    end

    def stats_params
      ### REFATORAR!!!
      ### não adianta por conta do to_unsafe_h
      params.permit(
        :preset,
        :data_chart,
        :average,
        :min_max,
        :sum,
        :unique_values,
        :total_keys,
        :total_listed
      )
    end

    def build_preset_params
      preset_hash = params[:preset].to_unsafe_h
      preset_hash = preset_encode(preset_hash)
      @preset_readed = DataPreset.read(preset_hash)
    end

    def clean_variables
      @data_set = nil
      @dynamic_content = nil
      @data_sets = nil
      @preset_readed = nil
      @pagy = nil
      @list_collection = nil
      @list_decoded = nil
      @page_selected = nil
      @per_page = nil
    end
end
