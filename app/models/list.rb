class List < ApplicationRecord
  belongs_to :project
  attribute :csv_json, :jsonb, default: []

  def preset(filter = {})
    # "#{self.cache_key}/preset/#{filter.to_s}"
    Rails.cache.fetch("#{self.cache_key}/preset/#{filter.to_s}", expires_in: 30.minutes) do
      @hashes_filtered = self.csv_json
      filter.each { |key, value|
        if value.class == Array
          begin
            data1 = Time.strptime(value[0], '%m/%d/%Y')
            data2 = Time.strptime(value[1], '%m/%d/%Y')
            @hashes_filtered = @hashes_filtered.select { |h| Time.strptime(h[key], '%m/%d/%Y') >= data1 && Time.strptime(h[key], '%m/%d/%Y') <= data2}
          rescue StandardError => e
            # jogar o erro e em um log
            float1 = value[0].to_f
            float2 = value[1].to_f
            @hashes_filtered = @hashes_filtered.select { |h| h[key].to_f >= float1 && h[key].to_f <= float2}
          end
        else
          @hashes_filtered = @hashes_filtered.select { |h| h[key] == value}
        end
      }
      @hashes_filtered
    end
  end

end
