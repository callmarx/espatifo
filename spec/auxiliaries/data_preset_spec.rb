require 'rails_helper'

RSpec.describe DataPreset do
  context 'Validation: messages errors' do
    it 'no logic key' do
      preset_params = {
        exp1: {aai: {not_include: "pinto"}},
        exp2: {aak: {greater_then: 15}}
      }
      expect(DataPreset.read preset_params).to eq([false, {
        :error=>"No 'logic' key!",
        :message=>"Read the API documentation"
      }])
    end
    it 'breckets not equal' do
      preset_params = {
        logic: "((exp1 and exp2)",
        exp1: {aai: {not_include: "pinto"}},
        exp2: {aak: {greater_then: 15}}
      }
      expect(DataPreset.read preset_params).to eq([false, {
        error: "Wrong logic key!",
        message:"number of breckets not equal."
      }])
    end
    it 'diffent number of exp in logic' do
      preset_params = {
        logic: "(exp1 and exp2)",
        exp1: {aai: {not_include: "pinto"}},
        exp2: {aak: {greater_then: 15}},
        exp3: {aak: {less_then: 29}}
      }
      expect(DataPreset.read preset_params).to eq([false, {
        error: "Wrong logic key",
        message:"number of 'exp' not equal."
      }])
      preset_params = {
        logic: "(exp1 and exp2)",
        exp1: {aai: {not_include: "pinto"}}
      }
      expect(DataPreset.read preset_params).to eq([false, {
        error: "Wrong logic key",
        message:"number of 'exp' not equal."
      }])
    end
  end
  context 'Unit test' do
    before do
      @preset_params = {
        logic: "((exp1 and exp2 and exp3 and exp4 and exp5))",
        exp1: {aai: {not_include: "pinto"}},
        exp2: {aak: {greater_then: 15}},
        exp3: {aak: {less_then: 29}},
        exp4: {aal: {greater_then: 1}},
        exp5: {adp: {exactly: "SP"}}
      }
    end
    it 'query verify' do
      expect(DataPreset.read @preset_params).to eq([true,
      "(not jsonb_path_exists(row, '$ ? ($.aai like_regex \"pinto\" flag \"i\")')) AND (row @@ '$.aak >= 15') AND (row @@ '$.aak <= 29') AND (row @@ '$.aal >= 1') AND (row @@ '$.adp == \"SP\"')"
      ])
    end
    it 'special characters not allowed in operators' do
      @preset_params[:exp1][:aai][:not_include] = "'"
      expect(DataPreset.read @preset_params).to eq([false, {
        error: "special character",
        message: "special characters not allowed in operators"
      }])
    end
    it 'special characters not allowed in operators' do
      @preset_params[:exp1][:aai] = {}
      @preset_params[:exp1][:aai][:operator_that_not_exist] = "some value"
      expect(DataPreset.read @preset_params).to eq([false, {
        error: "Wrong operator!",
        message:"operator 'operator_that_not_exist' do not exist in our logic :-("
      }])
    end
    it 'more than one operator per field' do
      @preset_params[:exp1][:aai][:include] = "some value"
      expect(DataPreset.read @preset_params).to eq([false, {
        error: "wrong operator",
        message: "each field need a hash with exactly one valid operator"
      }])
    end
    it 'less than one operator per field' do
      @preset_params[:exp1][:aai] = "not a hash"
      expect(DataPreset.read @preset_params).to eq([false, {
        error: "wrong operator",
        message: "each field need a hash with exactly one valid operator"
      }])
    end
  end
end
