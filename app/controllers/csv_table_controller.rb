class CsvTableController < ApplicationController
  before_action :set_project

  def index
    render json: @project.csv_table[params[:line_start].to_i..params[:line_end].to_i]
  end

  # POST
  def personalized_selection
    #  seila = teste.csv_table.select {|father| father["NU_IDADE"] == "16" && father["TP_SEXO"] == "2" && father["TP_COR_RACA"] == "5"}
      #  seila = teste.csv_table.select {|father| <JSON da requisição POST> }

  end


  private

  def set_project
    @project = Project.find(params[:id])
  end
end
