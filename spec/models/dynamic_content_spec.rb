require 'rails_helper'

RSpec.describe "DynamicContent", type: :model do
  before do
    @data_set = create(:data_set, keys_info: {
      aaa: 'Nome__STRING',
      aab: 'Renda_media__FLOAT_WITH_NA'
    })
  end
  it 'have a dynamic_model' do
    expect(@data_set.dynamic_content).to be("dynamic_content#{@data_set.id}".classify.constantize)
  end
  context 'validates' do
    it "row can't be empty" do
      dynamic_content = @data_set.dynamic_content.new
      expect(dynamic_content).to validate_presence_of(:row)
    end
    ## Por enquanto não é possivel fazer esse teste. Explicado no comentário do Model DataSet
    #it "row can't have keys there are no defined in data_set.keys_info" do
      #dynamic_content = @data_set.dynamic_content.new(row: {
      #  aaa: Faker::Name.name,
      #  aab: Faker::Number.decimal(r_digits: 5),
      #  aac: 'Same field that is not avaible'
      #})
      #puts "dynamic_content.row = #{dynamic_content.row.to_yaml}"
      #expect(dynamic_content.valid?).to be false
    #end
  end
end
