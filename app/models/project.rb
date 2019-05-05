class Project < ApplicationRecord
  belongs_to :client
  #serialize :csv_table, JSON
end
