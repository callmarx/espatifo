class List < ApplicationRecord
  belongs_to :project
  attribute :nosql_hash, :jsonb, default: []
end
