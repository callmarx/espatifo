require 'rails_helper'

RSpec.describe UndigestedInput, type: :model do
  context 'validates' do
    it {is_expected.to validate_presence_of(:name)}
    it {
      ui = build(:undigested_input, content: nil)
      ui.valid?
      expect(ui.errors[:content]).to include("can't be nil")
    }
    it {
      ui = build(:undigested_input, content: "nada a ver")
      ui.valid?
      expect(ui.errors[:content]).to include("must be a Array")
    }
  end
  context 'associations' do
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:data_set).optional}
  end
  context 'callbacks' do
    it 'default status' do
      ui = create(:undigested_input)
      expect(ui.status).to eq('todo')
    end
    it 'keys_info == {}' do
      ui = create(:undigested_input, keys_info: nil)
      expect(ui.keys_info).to eq({})
    end
  end
end
