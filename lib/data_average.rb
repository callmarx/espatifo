module DataPreset
  def self.get_average(filtered_list, average_params)
    result_average ={}
    average_params.each do |key|
      calc = calc_average(key, filtered_list)
      result_average[key] = {
            "total_NA": calc[0],
            "total_non_NA": calc[1],
            "average": calc[2]
      }
    end
    result_average
  end

  private
    def calc_average(key, filtered_list)
      total_non_NA = 0
      total_sum = 0.0
      total_NA = 0
      filtered_list.each do |entry|
        if entry.row[key] == "NA"
          total_NA += 1
        else
          total_non_NA += 1
          if entry.row[key].is_a? Numeric
            total_sum += entry.row[key].to_f
          else # Se não é numerico não tem como calcular a média :-)
            return [nil, nil, "Non Numeric field"]
          end
        end
      end
      return [total_NA, total_non_NA, total_sum/total_non_NA.to_f]
    end
end

