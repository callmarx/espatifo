class Report < ApplicationRecord
  belongs_to :user
  belongs_to :data_set
  has_one :data_info, as: :data_portion

  validates :name, presence: true
  validate :check_config_body_format

  private
  def check_config_body_format
    if !self.config_body
      self.errors.add :config_body, "can't be nil"
    end
    # implementar checagem do formato depois de implentar a função de preset
  end
end
