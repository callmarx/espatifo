require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validates' do
    it "email can't be empty" do
      is_expected.to validate_presence_of(:email)
    end
    it "password can't be empty" do
      is_expected.to validate_presence_of(:password)
    end
    it "password_confirmation can't be empty" do
      is_expected.to validate_presence_of(:password_confirmation)
    end

    it "email uniq" do
      is_expected.to validate_uniqueness_of(:email).case_insensitive
    end
  end
  #context 'associations' do
  #  it {is_expected.to have_many(:reports)}
  #end
end
