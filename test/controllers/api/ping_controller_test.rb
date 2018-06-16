require_relative './test_base'

class API::PingControllerTest < API::TestBase
  test "should return 200" do
    get api_ping_path, as: :json
    assert_response 200
  end
end
