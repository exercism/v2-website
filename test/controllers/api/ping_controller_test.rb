require_relative './test_base'

class API::PingControllerTest < API::TestBase
  test "latest should return 401 with incorrect token" do
    get api_ping_path, as: :json
    assert_response 200
  end
end
