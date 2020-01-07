class Report < ApplicationRecord
  belongs_to :user
  belongs_to :data_set
  has_one :data_info, as: :data_portion

  validates :name, presence: true
  validate :check_preset_format

  private
  def check_preset_format
    if !self.preset
      self.errors.add :preset, "can't be nil"
    end
    # implementar checagem do formato depois de implentar a função de preset
  end
end
