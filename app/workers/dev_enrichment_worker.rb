class DevEnrichmentWorker
  include Sidekiq::Worker
  sidekiq_options queue: "#{ENV['SIDEKIQ_QUEUE_PREFIX']}_#{ENV['RAILS_ENV']}_default"

  def perform(data_set_id, csv_file)
    data_set = DataSet.find_by_id(data_set_id)
    #class_name = "DynamicContent#{data_set_id}"

    path = Rails.root.join('tmp', 'csv', csv_file)
    header = CSV.open(path, col_sep: ';', &:readline)

    ## Gera o keys_info do data_set
    ## Utilizar keys longas ocupa mais espação no banco, isso é feito para ter mais espaço no banco
    ## em contrapartida será necessario fazer a conversão (gasta em um pouco de processamento)
    ## Fonte:
    ## https://dba.stackexchange.com/questions/161864/do-long-names-for-jsonb-keys-use-more-storage
    alphabet = ("a".."z").to_a
    header.each_with_index do |col, index|
      first_place = index%26
      second_place = ((index - first_place)/26)%26
      third_place = ((index - second_place*26 - first_place)/(26*26))%26
      key = alphabet[third_place] + alphabet[second_place] + alphabet[first_place]
      data_set.keys_info[key] = col
    end
    data_set.save

    CSV.foreach(path, col_sep: ';', row_sep: :auto, headers: true) do |row|
      final_hash = Hash.new
      header.each do |col|
        if col.include? "WITH_NA" and row[col].strip == "NA"
          final_hash[data_set.keys_info.key(col)] = "NA" # por nil qdo nao trabalhar com NA
        else
          attribute_type = col.split("__").last.gsub('_WITH_NA', '').gsub('_UNIQUE','')
          case
          when (attribute_type.include? 'INTEGER')
            if attribute_type.include? 'ARRAY'
              final_hash[data_set.keys_info.key(col)] = row[col].split('@!').map(&:to_i)
            else
              final_hash[data_set.keys_info.key(col)] = row[col].to_i
            end
          when (attribute_type.include? 'FLOAT')
            if attribute_type.include? 'ARRAY'
              final_hash[data_set.keys_info.key(col)] = row[col].split('@!').map(&:to_f)
            else
              final_hash[data_set.keys_info.key(col)] = row[col].to_f
            end
          when (attribute_type.include? 'BOOLEAN_NUMERAL')
            if attribute_type.include? 'ARRAY'
              puts "@Arbex! Carro voador"
            else
              final_hash[data_set.keys_info.key(col)] = row[col].to_i
            end
          else # STRING' e 'DATE'
            if attribute_type.include? 'ARRAY'
              final_hash[data_set.keys_info.key(col)] = row[col].split('@!').map(&:strip)
            else
              final_hash[data_set.keys_info.key(col)] = row[col]
            end
          end
        end
      end
      data_set.dynamic_content.create!(row: final_hash)
    end
  end
end
