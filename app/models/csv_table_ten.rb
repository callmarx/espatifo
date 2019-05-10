class CsvTableTen < ApplicationRecord
  attribute :csv_content, :jsonb, default: []
end
