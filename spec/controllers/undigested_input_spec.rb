require 'rails_helper'

RSpec.describe "AdminDashboardController", :type => :request do
  before(:each) do
    @user = create(:user)
    @auth_headers = get_header_auth @user
  end

  it "Authorization" do
    @user.admin!
    # index
    get '/dashboard/undigested_input/', headers: @auth_headers
    expect(response).to have_http_status(:success)
    @user.standard!
    # index
    get '/dashboard/undigested_input/', headers: @auth_headers
    expect(response).to have_http_status(401)
    @user.moderator!
    # index
    get '/dashboard/undigested_input/', headers: @auth_headers
    expect(response).to have_http_status(:success)
  end

  context "with UI" do
    before do
      @user = create(:user, permission: 'moderator')
      @auth_headers = get_header_auth @user
      3.times{ create(:undigested_input, user: @user) }
      @uis = @user.undigested_inputs

      @user2 = create(:user, permission: 'moderator')
      @auth_headers2 = get_header_auth @user2
      3.times{ create(:undigested_input, user: @user2) }
      @uis2 = @user2.undigested_inputs

      @admin = create(:user, permission: 'admin')
      @auth_headers_admin = get_header_auth @admin
    end
    it "default create" do
      params_create = {
        undigested_input: {
          name: "UI teste",
          description: "Descrição teste do UI",
          content: [
            { cpf: 12345678900, nome: "Fulano"},
            { cpf: 77777777777, nome: "Beltrano"}
          ]
        }
      }
     post '/dashboard/undigested_input', headers: @auth_headers, params: params_create, as: :json
     expect(response).to have_http_status(:created)
     expect(JSON.parse response.body).to include(params_create[:undigested_input].as_json)
    end
    it "not owner show" do
      get "/dashboard/undigested_input/#{@uis2.sample.id}", headers: @auth_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse response.body).to include(
        {"undigested_input_error" => "You don't have this undigested_input"}
      )
    end
    it "owner show" do
      get "/dashboard/undigested_input/#{@uis.first.id}", headers: @auth_headers
      expect(response).to have_http_status(:success)
      expect(JSON.parse response.body).to include(@uis.first.as_json(
        except: [:data_set_id, :keys_info]
     ))
    end
    it "admin show" do
      get "/dashboard/undigested_input/#{@uis.first.id}", headers: @auth_headers_admin
      expect(response).to have_http_status(:success)
      expect(JSON.parse response.body).to include(@uis.first.as_json(
        except: [:data_set_id, :keys_info]
     ))
    end
    #it "index admin" do
    #  get '/dashboard/undigested_input', headers: @auth_headers_admin
    #  expect(response).to have_http_status(:success)
    #  expect((JSON.parse response.body).map{ |ui| ui.except("data_set", "total_content")}).to eq(
    #    @uis.append(@uis2).map{ |ui| ui.as_json(
    #      except: [:data_set_id, :keys_info]
    #    )}
    #  )
    #end
    #it "update" do
    #end
    #it "index" do
    #end
    #it "link data_set" do
    #end
  end
end
