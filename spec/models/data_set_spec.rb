require 'rails_helper'

RSpec.describe DataSet, type: :model do
  context 'validates' do
    it {is_expected.to validate_presence_of(:name)}
    #it { is_expected.to validate_presence_of(:keys_info) }
    ## Como presence:true não permite vazio {}, preciso restrigir a nil
    it "keys_info can't be nil" do
      data_set = build(:data_set, keys_info: nil)
      data_set.valid?
      expect(data_set.errors.messages[:keys_info]).to include("can't be nil")
    end
  end
  context 'relations' do
    it {is_expected.to have_one(:data_info)}
  end

  context 'keys_info format' do
    it 'key must have 3 lowercase letters' do
      data_set = build(:data_set, keys_info: { aaaa: 'key with more then 3 characters'})
      data_set.valid?
      expect(data_set.errors.messages[:keys_info]).to include('The keys must have exactly 3 lowercase letters')
      data_set = build(:data_set, keys_info: { aa: 'key with less then 3 characters'})
      data_set.valid?
      expect(data_set.errors.messages[:keys_info]).to include('The keys must have exactly 3 lowercase letters')
      data_set = build(:data_set, keys_info: { aaA: 'key with upcase characters'})
      data_set.valid?
      expect(data_set.errors.messages[:keys_info]).to include('The keys must have exactly 3 lowercase letters')
    end
  end
end
