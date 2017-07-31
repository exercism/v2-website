require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  test "index renders" do
    get tracks_url
    assert_response :success
    assert_correct_page "tracks-page"
  end

  test "show renders" do
    get track_url(create :track)
    assert_response :success
    assert_correct_page "track-page"
  end
end
