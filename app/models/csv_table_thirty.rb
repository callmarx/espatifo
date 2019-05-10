class CsvTableThirty < ApplicationRecord
  attribute :csv_content, :jsonb, default: []
end
