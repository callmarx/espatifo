class Employee < ApplicationRecord
  has_one :login, as: :user
  belongs_to :company
  has_many :projects, through: :company
end
