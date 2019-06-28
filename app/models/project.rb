class Project < ApplicationRecord
  belongs_to :company
  has_many :lists
  has_and_belongs_to_many :users
end
