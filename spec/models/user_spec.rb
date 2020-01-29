require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validates' do
    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to validate_presence_of(:password)}
    it {is_expected.to validate_presence_of(:password_confirmation)}
    it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
    it {is_expected.to define_enum_for(:permission)}
  end
  context 'associations' do
    it {is_expected.to have_many(:reports)}
    it {is_expected.to have_many(:undigested_inputs)}
  end
  context 'callbacks' do
    it 'default permission' do
      user = create(:user)
      expect(user.permission).to eq('standard')
    end
  end
end
