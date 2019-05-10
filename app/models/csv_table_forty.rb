class CsvTableForty < ApplicationRecord
  attribute :csv_content, :jsonb, default: []
end
