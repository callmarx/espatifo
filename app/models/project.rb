class Project < ApplicationRecord
  belongs_to :client
  has_one :csv_table_ten
  has_one :csv_table_twenty
  has_one :csv_table_thirty
  has_one :csv_table_forty
  has_one :csv_table_fifty
  # attribute :csv_table00001_10000, :jsonb, default: {}
  # attribute :csv_table10001_20000, :jsonb, default: {}
  # attribute :csv_table20001_30000, :jsonb, default: {}
  # attribute :csv_table30001_40000, :jsonb, default: {}
  # attribute :csv_table40001_50000, :jsonb, default: {}

  #serialize :csv_table, JSON
end
