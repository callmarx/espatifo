require 'devise/jwt/test_helpers'

module UserToken
  def get_user_and_header
    user = create(:user)
    post '/login', params: {
      user: {
        email: user.email,
        password: '123456'
      }
    }
    headers = {
      'Authorization' => response.headers['Authorization']
    }
    [user, headers]
  end

  #def get_login_token(user)
    #old_controller = @controller
    #@controller = ApplicationController.new
    #post '/login', params: {
    #  user: {
    #    email: user.email,
    #    password: '123456'
    #  }
    #}
    #@controller = old_controller
    #puts "dentro do NOVO modulo:: response.body = #{response.body}"
    #puts "dentro do NOVO modulo:: response.headers = #{response.headers}"
    #puts "dentro do NOVO modulo:: response.headers['Authorization'] = #{response.headers['Authorization']}"
    #headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    #headers['Authorization'] = response.headers['Authorization']
    #headers
  #end
end
