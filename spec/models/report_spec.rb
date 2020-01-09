require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'validates' do
    it {is_expected.to validate_presence_of(:name)}
    it "preset can't be nil" do
      report = build(:report, preset: nil)
      report.valid?
      expect(report.errors.messages[:preset]).to include("can't be nil")
    end
  end
  context 'associations' do
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:data_set)}
    it {is_expected.to have_one(:data_info)}
  end

  context 'preset format' do
    # implementar depois de fazer as funções de preset
  end
end
