module Listable
  extend ActiveSupport::Concern

  def get_preset(preset_params)
    Rails.cache.fetch([@list.cache_key, __method__, preset_params.to_s], expires_in: 30.minutes) do
      hashes_filtered = @list.csv_json
        preset_params.each do |key, value|
          if value.class == Array
            begin
              data1 = Time.strptime(value[0], '%m/%d/%Y')
              data2 = Time.strptime(value[1], '%m/%d/%Y')
              hashes_filtered = hashes_filtered.select { |h| Time.strptime(h[key], '%m/%d/%Y') >= data1 && Time.strptime(h[key], '%m/%d/%Y') <= data2}
            rescue StandardError => e
              # jogar o erro e em um log
              float1 = value[0].to_f
              float2 = value[1].to_f
              hashes_filtered = hashes_filtered.select { |h| h[key].to_f >= float1 && h[key].to_f <= float2}
            end
          elsif value.class == ActionController::Parameters
            value.each do |key2, value2|
              case key2
              when "include"
                hashes_filtered = hashes_filtered.select { |h| h[key].include? value2}
              when "not_include"
                hashes_filtered = hashes_filtered.select { |h| !(h[key].include? value2)}
              else
                hashes_filtered = hashes_filtered.select { |h| h[key] == value}
              end
            end
          else
            hashes_filtered = hashes_filtered.select { |h| h[key] == value}
          end
        end
      hashes_filtered
    end
  end

  def get_graph_data(preset_params)
    Rails.cache.fetch([@list.cache_key, __method__, preset_params.to_s], expires_in: 30.minutes) do
      result = {list_id: @list.id}
      if preset_params
        result[:preseted] = true
        csv_json = get_preset(preset_params)
      else
        result[:preseted] = false
        csv_json = @list.csv_json
      end
      result[:total_listed] = csv_json.count
      result[:graph_data] = {}
      total = csv_json.count
      csv_json.first.each do |key, value|
        result[:graph_data][key] = {
          total_diff: 0,
          total_each: {}
        }
        csv_json.each do |line|
          if result[:graph_data][key][:total_each].has_key? line[key]
            result[:graph_data][key][:total_each][line[key]][0] += 1
          else
            result[:graph_data][key][:total_diff] += 1
            result[:graph_data][key][:total_each][line[key]] = [1, 0.0]
          end
        end
      end
      result[:graph_data].each do |key, value|
        result[:graph_data][key][:total_each].each do |key2, value2|
          result[:graph_data][key][:total_each][key2][1] = (value2[0].to_f/total.to_f)*100.0
        end
      end
      result
    end
  end

end
