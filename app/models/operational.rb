class Operational < ApplicationRecord
  has_one :login, as: :user
end
