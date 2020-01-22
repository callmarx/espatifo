class ReportsController < ApplicationController
  include ControllerDataResolve
  include ReportConcern
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :set_report, only: [:show, :update, :destroy]
  before_action :set_dynamic_content, only: [:download_csv_preset, :show]
  before_action :set_paginate_params, only: [:preset]

  # GET /reports
  def index
    @reports = Report.order('id ASC')

    render json: @reports, except: [:data_set_id, :user_id], include: [
      data_set: {except: [:keys_info]},
      user: {only: [:id, :email]}
    ]
  end

  # GET /reports/1
  def show
    #render json: @report, except: [:data_set_id, :user_id], include: [
      #data_set: {except: [:keys_info]},
      #user: {only: [:id, :email]}
    #]
    render json: @report.as_json.except("data_set_id", "user_id").merge(
      {"data_set" => @data_set.as_json.except("keys_info").merge(
        {"total_listed" => @dynamic_content.count}
      )},
      {"user" => @report.user.as_json(:only => [:id, :email])}
    )
  end

  ## GET /reports/1/preset
  #def preset
  #  result = get_preset(@report.config_body["preset"]) # devolve tupla --> [true ou false, response body]
  #  if result[0]
  #    list = result[1]
  #    if @report.config_body["average"]
  #      result_average = get_average(list, @report.config_body["average"])
  #    else
  #      result_average = nil
  #    end
  #    @pagy, @list_paginated = pagy(list, items: @per_page)
  #    render json: {
  #      total_listed: @pagy.count,
  #      total_pages: @pagy.pages,
  #      current_page: @page_selected,
  #      per_page: @per_page,
  #      average: result_average,
  #      result: @list_paginated
  #    }
  #  else
  #    render json: result[1], status: :bad_request
  #  end
  #end

  # GET /reports/1/download
  def download_csv_preset
    preset_params = @report.config_body["preset"]
    if preset_params
      preset_hash = preset_encode(preset_params)
      preset_readed = DataPreset.read(preset_hash)
      if preset_readed.first
        @list_collection = @dynamic_content.where(Arel.sql(preset_readed.last))
      else
        render json: preset_readed.last, status: :bad_request
        return
      end
    else
      @list_collection = @dynamic_content.all
    end
    file_name = generate_csv(@list_collection)
    send_file file_name, type: "text/csv", x_sendfile: true#,disposition: "attachment"
    #File.delete(file_name) if File.exist?(file_name)
  end

  # POST /data_sets/1/reports
  def create
    @report = current_user.reports.new(report_params.merge({data_set_id: params[:data_set_id]}))
    if @report.save
      render json: @report, except: [:data_set_id, :user_id], include: [
        data_set: {except: [:keys_info]},
        user: {only: [:id, :email]}
      ], status: :created
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1
  def update
    if current_user != @report.user
      render json: {error: "Only the report's owner can edit it"}, status: :unauthorized
    elsif @report.update(report_params)
      render json: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1
  def destroy
    if current_user != @report.user
      render json: {error: "Only the report's owner can destroy it"}, status: :unauthorized
    else
      @report.destroy
      render status: :no_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find_by_id(params[:id])
    end

    def set_dynamic_content
      set_report
      @data_set = @report.data_set
      @dynamic_content = @data_set.dynamic_content
    end

    # parametros de url para paginação
    def set_paginate_params
      @page_selected = params[:page] || 1
      @per_page = params[:per_page] || 30
    end

    # Only allow a trusted parameter "white list" through.
    def report_params
      params.require(:report).to_unsafe_h
    end
end
