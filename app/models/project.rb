class Project < ApplicationRecord
  belongs_to :client
  has_one :list
end
