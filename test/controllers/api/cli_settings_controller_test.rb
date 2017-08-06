require_relative './test_base'

class API::CLISettingsControllerTest < API::TestBase
  test "setup should return 401 with incorrect token" do
    get api_cli_settings_path, as: :json
    assert_response 401
  end

  test "setup should return 200 with valid track" do
    setup_user
    get api_cli_settings_path, headers: @headers, as: :json
    assert_response 200
  end
end

