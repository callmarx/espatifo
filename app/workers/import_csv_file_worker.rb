class ImportCsvFileWorker
  include Sidekiq::Worker

  def perform(csv_file, project_id)
    @project = Project.find(project_id)
    path = Rails.root.join('lib', 'csv_path', csv_file)
    @project.csv_table = CSV.open(path, {headers: :first_row, col_sep: "|"}).map(&:to_h)
    @project.save
  end

end
