require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "successfully loads solutions for profile" do
    sign_in!
    user = @current_user
    track = create(:track)

    create(:user_track, track: track, user: user)
    create(:profile, user: user)

    solution = create(:solution,
                       user: user,
                       exercise: create(:exercise, title: "Exercise 1", track: track),
                       published_at: Date.new(2016, 12, 25))

    get solutions_profile_path(user.handle), params: {
      track_id: track.id,
      format: :js
    },
    xhr: true

    assert_response :success
    assert_equal assigns(:solutions), [solution]
  end
end
