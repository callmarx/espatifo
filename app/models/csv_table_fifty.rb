class CsvTableFifty < ApplicationRecord
  attribute :csv_content, :jsonb, default: []
end
