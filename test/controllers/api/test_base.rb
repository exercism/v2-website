require 'test_helper'

module API
  class TestBase < ActionDispatch::IntegrationTest
    def setup_user
      @current_user = create :user
      @current_user.confirm
      auth_token = create :auth_token, user: @current_user
      @headers = {'Authorization' => "Token token=#{auth_token.token}"}
    end
  end
end
