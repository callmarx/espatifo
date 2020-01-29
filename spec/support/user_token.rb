require 'devise/jwt/test_helpers'

module UserToken
  def get_header_auth(user)
    #user = create(:user)
    post '/login', params: {
      user: {
        email: user.email,
        password: '123456'
      }
    }
    headers = {
      'Authorization' => response.headers['Authorization']
    }
    #[user, headers]
    headers
  end
end
