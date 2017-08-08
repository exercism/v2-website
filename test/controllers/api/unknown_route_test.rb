require_relative './test_base'

class API::UnknownRouteTest < API::TestBase
  [
    "/api/foobar", 
    "/api/v1/foobar"
  ].each do |route|
    test "routing to a missing page 401s with json for #{route}" do
      get route
      assert_response 401
    end
  end

  [
    "/api/foobar", 
    "/api/v1/foobar"
  ].each do |route|
    test "routing 404s with json for #{route}" do
      setup_user
      get route, headers: @headers, as: :json
      assert_response 404
      expected = {"error"=>{"type"=>"resource_not_found", "message"=>"Resource not found"}}
      assert_equal expected, JSON.parse(response.body)
    end
  end
end
