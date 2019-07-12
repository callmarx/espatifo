class ImportListJob < ApplicationJob
  queue_as :default

  def perform(project_id, list_file)
    @list = List.new(project_id: project_id)
    path = Rails.root.join('tmp', 'csv_path', list_file)

    @list.csv_json = []
    CSV.foreach(path, headers: true).with_index do |row, index|
      @list.csv_json << row.to_hash.merge("index" => index + 1)
    end
    ## Linhas de cima podem ser feitas em uma linha:
    # @list.csv_json = CSV.open(path, {headers: :first_row}).map.with_index { |ch, idx| [ ch.to_h.merge!("index" => idx + 1 )] } # Com index
    
    @list.save
  end
end
