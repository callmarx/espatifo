class DataSetsController < ApplicationController
  include Pagy::Backend
  include ControllerDataResolve
  #before_action :authenticate_user!
  before_action :set_data_set, only: [:show]
  before_action :set_dynamic_content, only: [:list, :show_subject, :stats]
  before_action :set_paginate_params, only: [:list]
  before_action :list_params, only: [:list]
  before_action :stats_params, only: [:stats]

  # GET /data_sets
  def index
    @data_sets = DataSet.order('id ASC')
    render json: @data_sets, except: [:keys_info]
  end

  # GET /data_sets/1
  def show
    render json: @data_set, except: [:keys_info]
  end

  # GET /data_sets/1/1
  def show_subject
    
  end

  # POST /data_sets/1/list
  def list
    ## BODY parametros:
    # preset
    if params[:preset]
      preset_hash = params[:preset].to_unsafe_h
      #Rails.logger.info "###### preset_hash = #{JSON.pretty_generate preset_hash}"
      # preset_encode --> em private method
      preset_hash = preset_encode(preset_hash)
      #Rails.logger.info "###### preset_hash_encoded = #{JSON.pretty_generate preset_hash}"
      preset_readed = DataPreset.read(preset_hash)
      #Rails.logger.info "###### preset_readed = #{preset_readed.last}"
      if !preset_readed.first
        render json: preset_readed.last, status: :bad_request
        return
      else
        @pagy, @list_paginated = pagy(
          @dynamic_content.where(Arel.sql(preset_readed.last)).order(order_query),
          items: @per_page
        )
      end
    else
      @pagy, @list_paginated = pagy(@dynamic_content.order(order_query), items: @per_page)
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
    # graph_data
    # average
    # min_max
    # sum
    # unique
    # total_keys

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      @data_set = DataSet.find(params[:id])
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
        :graph_data,
        :average,
        :min_max,
        :sum,
        :unique_values,
        :total_keys
      )
    end
end
