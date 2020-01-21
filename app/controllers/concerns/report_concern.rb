module ReportConcern
  extend ActiveSupport::Concern

  private
  def generate_csv(filtered_list)
    header = @data_set.keys_info.values 
    header.unshift "id"
    file_name = "public/#{Time.now.to_i}_report_id_#{@report.id}.csv"
    CSV.open(file_name,"a", write_headers: true, headers: header) do |csv|
      filtered_list.each do |entry|
        row = CSV::Row.new(header,[])
        row["id"] = entry.id
        entry.row.each do |key, value|
          row[@data_set.decode_key key] = value
        end
        csv << row
      end
    end
    file_name
  end
end
