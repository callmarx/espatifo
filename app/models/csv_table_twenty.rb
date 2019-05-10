class CsvTableTwenty < ApplicationRecord
  attribute :csv_content, :jsonb, default: []
end
