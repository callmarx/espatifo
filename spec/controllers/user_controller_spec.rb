require 'rails_helper'
require 'devise'

RSpec.describe User::RegistrationsController, type: :controller do

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  #before do
  #  @user = create(:user)
  #end

  it "#create" do
    post :create, params: { user: attributes_for(:user) }
    expect(response).to have_http_status(200)
  end
end
