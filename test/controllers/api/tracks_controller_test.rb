require_relative './test_base'

class API::SolutionsControllerTest < API::TestBase
  test "show should return 401 with incorrect token" do
    get api_track_path(1), as: :json
    assert_response 401
  end

  test "show should return 404 when there is no track" do
    setup_user
    get api_track_path(SecureRandom.uuid), headers: @headers, as: :json
    assert_response 404
    expected = {error: "Track not found", fallback_url: tracks_url}
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end

  test "show should return 200 with valid track" do
    @mock_repo = mock(test_pattern: ".*")
    Git::ExercismRepo.stubs(new: @mock_repo)

    setup_user
    track = create :track
    get api_track_path(track.slug), headers: @headers, as: :json
    assert_response 200

    expected = {
      track: {
        id: track.slug,
        language: track.title,
        test_pattern: ".*"
      }
    }
    actual = JSON.parse(response.body, symbolize_names: true)
    assert_equal expected, actual
  end
end
