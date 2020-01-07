require 'rails_helper'

RSpec.describe DataInfo, type: :model do
  before do
    @data_info = create(:data_info)
  end
  context 'validates' do
    it "chart_info can't be nil" do
      data_info = build(:data_info, chart_info: nil)
      data_info.valid?
      expect(data_info.errors.messages[:chart_info]).to include("can't be nil")
    end
    it "min_max can't be nil" do
      data_info = build(:data_info, min_max: nil)
      data_info.valid?
      expect(data_info.errors.messages[:min_max]).to include("can't be nil")
    end
  end
  context 'associations' do
    it {is_expected.to belong_to(:data_portion)}
  end
end
