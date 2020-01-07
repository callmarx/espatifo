class DataInfo < ApplicationRecord
  belongs_to :data_portion, polymorphic: true
  validate :check_chart_info, :check_min_max

  private
  def check_chart_info
    if !self.chart_info
      self.errors.add :chart_info, "can't be nil"
    end
  end
  def check_min_max
    if !self.min_max
      self.errors.add :min_max, "can't be nil"
    end
  end
end
