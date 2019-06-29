class List < ApplicationRecord
  belongs_to :project
  attribute :csv_json, :jsonb, default: []
end
