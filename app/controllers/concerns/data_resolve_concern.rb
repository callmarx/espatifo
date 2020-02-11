module DataResolveConcern
  extend ActiveSupport::Concern

  private
    def relation_decode
      @list_decoded = @list_collection.map(&:as_json)
      @list_collection.each_with_index do |obj, idx|
        @list_decoded[idx]['row'].transform_keys!{ |k| @data_set.decode_key(k)}
      end
    end

    def preset_encode(preset_hash)
      preset_encoded = preset_hash.except("logic").map{
        |key,value| [key, value.transform_keys{
          |sub_key| @data_set.encode_key(sub_key)
        }]
      }.to_h
      preset_encoded[:logic] = preset_hash["logic"]
      preset_encoded
    end

    def order_query
      order_field = params[:order_field]
      order_by = params[:order_by]
      if !order_field
        Arel.sql("id ASC")
      elsif order_by == 'DESC'
        Arel.sql("row->'#{@data_set.encode_key order_field}' DESC")
      else
        Arel.sql("row->'#{@data_set.encode_key order_field}' ASC")
      end
    end

    def get_chart(keys_params)
      keys = keys_params.map{|k| @data_set.encode_key(k)}
      total_listed = @list_collection.count(:all)
      data_chart = {}
      return data_chart if total_listed == 0
      keys.each do |key|
        # cada chave do meu datalist eu crio uma hash com total_diff e total_each
        data_chart[key] = {
          total_diff: 0,
          total_each: {}
        }
        # total_diff: a quantidade de valores distintos da minha coleção para essa chave
        # total_each: sub_hash com uma chave para cada valor distinto da minha coleção
        @list_collection.each do |subject|
          # if subject.row[key]
          #  key_value = subject.row[key]
          #else
          #  key_value = "NA"
          #end
          if data_chart[key][:total_each].has_key? subject.row[key]
            data_chart[key][:total_each][subject.row[key]][0] += 1
          else
            data_chart[key][:total_diff] += 1
            data_chart[key][:total_each][subject.row[key]] = [1, 0.0]
          end
        end
        # Com resultados de total_each consigo a % de cada valor unico em relação ao total de @list_collection
        data_chart[key][:total_each].each do |key2, value|
          data_chart[key][:total_each][key2][1] = (value[0].to_f/total_listed.to_f)*100.0
        end
      end
      data_chart.transform_keys{|k| @data_set.decode_key(k)}
    end

    def get_average(average_params)
      average ={}
      average_params.each do |key|
        calc = calc_average(key)
        average[key] = {
              "total_NA": calc[0],
              "total_non_NA": calc[1],
              "average": calc[2]
        }
      end
      average
    end

    def calc_average(key_decoded)
      key = @data_set.encode_key(key_decoded)
      total_non_NA = 0
      total_sum = 0.0
      total_NA = 0
      @list_collection.each do |subject|
        ## Troca linha abaixo se não houver NA na base (for NULL)
        ## ficaria:
        ##    if !subject.row[key]
        ## Porem têm que existir em keys_info
        if subject.row[key] == "NA"
          total_NA += 1
        else
          total_non_NA += 1
          if subject.row[key].is_a? Numeric
            total_sum += subject.row[key].to_f
          else # Se não é numerico não tem como calcular a média :-)
            return [nil, nil, "Non Numeric field"]
          end
        end
      end
      return [total_NA, total_non_NA, total_sum/total_non_NA.to_f]
    end

    def get_min_max(min_max_params)
      ### ATENÇÃO: Não checa se o campo é Numérico
      min_max = {}
      min_max_params.each do |key|
        key_encoded = @data_set.encode_key(key)
        values_array = @list_collection.map{
            |s| s.row[key_encoded] if s.row[key_encoded].is_a? Numeric
          }.compact
        min_max[key] = {
          min: values_array.min,
          max: values_array.max
        }
      end
      min_max
    end

    def get_sum(sum_params)
      ### ATENÇÃO: Não checa se o campo é Numérico
      sum = {}
      sum_params.each do |key|
        key_encoded = @data_set.encode_key(key)
        sum[key] = @list_collection.map{
          |s| s.row[key_encoded] if s.row[key_encoded].is_a? Numeric
        }.compact.sum
      end
      sum
    end

    def get_unique_values(unique_values_params)
      ### ATENÇÃO: Não checa se o campo é Numérico
      unique_values = {}
      unique_values_params.each do |key|
        key_encoded = @data_set.encode_key(key)
        unique_values[key] = @list_collection.map{ |s| s.row[key_encoded]}.uniq
      end
      unique_values
    end
end
