class Project < ApplicationRecord
  belongs_to :client
  attribute :csv_table, :jsonb, default: {}
  #serialize :csv_table, JSON
end
