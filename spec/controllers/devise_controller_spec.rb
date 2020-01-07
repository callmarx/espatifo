require 'rails_helper'

RSpec.describe "Devise Controllers", :type => :request do
  before(:each) do
    @user, @auth_headers = get_user_and_header
  end
  context "log in and sign up methods" do
    it "create a user" do
      user = build(:user)
      post '/signup', params: {
        user: {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          password: '123456',
          password_confirmation: '123456'
        }
      }
      expect(response).to have_http_status(:success)
    end
    it "login" do
      #puts "log in @user.email = #{@user.email}"
      expect(@auth_headers['Authorization']).to_not be_nil
    end
    it "update a user" do
      #puts "update @user.email = #{@user.email}"
      put '/signup', headers: @auth_headers, params: {
        user: {
          first_name: 'updated name',
          current_password: '123456'
        }
      }
      expect(response).to have_http_status(:success)
      expect(JSON.parse response.body).to include("first_name" => 'updated name')
    end
    it "destroy a user" do
      #puts "destroy @user.email = #{@user.email}"
      delete '/signup', headers: @auth_headers
      expect(response).to have_http_status(:success)
      expect(User.find_by_id @user.id).to be_nil
    end
  end
end
