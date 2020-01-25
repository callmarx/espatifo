require 'rails_helper'

RSpec.describe "DataSetsController", :type => :request do
  before(:all) do
    @user, @auth_headers = get_user_and_header
    @data_set_1 = create(:data_set)
    @data_set_2 = create(:data_set)
    @data_set_3 = create(:data_set)
  end
  it "index" do
    get '/data_sets', headers: @auth_headers
    expect(
      JSON.parse(response.body)[0].except("enriched")
    ).to eq(@data_set_1.as_json.except("keys_info"))
    expect(
      JSON.parse(response.body)[1].except("enriched")
    ).to eq(@data_set_2.as_json.except("keys_info"))
    expect(
      JSON.parse(response.body)[2].except("enriched")
    ).to eq(@data_set_3.as_json.except("keys_info"))
  end
  it "show" do
    get "/data_sets/#{@data_set_1.id}", headers: @auth_headers
    expect(
      JSON.parse(response.body)
    ).to eq(
      @data_set_1.as_json.except("keys_info").merge({"total_listed"=>0, "total_keys"=>[]})
    )
  end
end
