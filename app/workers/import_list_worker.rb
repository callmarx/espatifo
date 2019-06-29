class ImportListWorker
  include Sidekiq::Worker

  def perform(project_id, list_file)
    @list = List.new(project_id: project_id)
    path = Rails.root.join('tmp', 'csv_path', list_file)
    @list.csv_json = CSV.open(path, {headers: :first_row}).map(&:to_h)
    @list.save

    # # Com demilitador diferente de ','
    # @list = List.new(project_id: project_id)
    # path = Rails.root.join('lib', 'csv_path', list_file)
    # @list.csv_json = CSV.open(path, {headers: :first_row, col_sep: "|"}).map(&:to_h)
    # @list.save


    # project = Project.find(project_id)
    # path = Rails.root.join('lib', 'csv_path', csv_file)
    #
    # project.csv_table.new = []
    # CSV.foreach(path, {headers: :first_row, col_sep: "|"}).with_index(1) do |line, count|
    #   break if count > 10000
    #   project.csv_table00001_10000 << line.to_h
    # end
    # project.csv_table10001_20000 = []
    # CSV.foreach(path, {headers: :first_row, col_sep: "|"}).with_index(10001) do |line, count|
    #   break if count > 20000
    #   project.csv_table10001_20000 << line.to_h
    # end
    #
    # project.save

    # path = Rails.root.join('lib', 'csv_path', csv_file)
    # case interval
    # when 1
    #   csvtable = CsvTableTen.new(project_id: project_id, total_lines: total_lines)
    # when 2
    #   csvtable = CsvTableTwenty.new(project_id: project_id, total_lines: total_lines)
    # end
    #
    # csvtable.csv_content = []
    # CSV.foreach(path, {headers: :first_row, col_sep: "|"}) do |line|
    #   csvtable.csv_content << line.to_h
    # end
    # csvtable.save


  end

end
