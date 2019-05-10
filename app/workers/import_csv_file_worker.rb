class ImportCsvFileWorker
  include Sidekiq::Worker

  def perform(csv_file, interval, total_lines, project_id)
    # @project = Project.find(project_id)
    # path = Rails.root.join('lib', 'csv_path', csv_file)
    # @project.csv_table = CSV.open(path, {headers: :first_row, col_sep: "|"}).map(&:to_h)
    # @project.save

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

    path = Rails.root.join('lib', 'csv_path', csv_file)
    case interval
    when 1
      csvtable = CsvTableTen.new(project_id: project_id, total_lines: total_lines)
    when 2
      csvtable = CsvTableTwenty.new(project_id: project_id, total_lines: total_lines)
    end

    csvtable.csv_content = []
    CSV.foreach(path, {headers: :first_row, col_sep: "|"}) do |line|
      csvtable.csv_content << line.to_h
    end
    csvtable.save
    #
    # if total_lines < 10001
    #   return
    # end

  end

end
