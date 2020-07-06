# frozen_string_literal: true

class DataInfo < ApplicationRecord
  belongs_to :data_portion, polymorphic: true
  validate :check_chart_info, :check_min_max

  private

  def check_chart_info
    self.errors.add :chart_info, "can't be nil" unless self.chart_info
  end

  def check_min_max
    self.errors.add :min_max, "can't be nil" unless self.min_max
  end
end
