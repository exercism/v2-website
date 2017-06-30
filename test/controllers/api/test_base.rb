require 'test_helper'

class API::TestBase < ActionDispatch::IntegrationTest
  def setup_user
    @current_user = create :user
    auth_token = create :auth_token, user: @current_user
    @headers = {'Authorization' => "Token token=#{auth_token.token}"}
  end
end
