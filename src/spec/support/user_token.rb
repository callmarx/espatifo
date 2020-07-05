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
end
