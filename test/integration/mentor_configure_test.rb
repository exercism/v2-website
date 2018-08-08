require 'test_helper'

class MentorConfigureTest < ActionDispatch::IntegrationTest
  test "mentors configuring can see what tracks they already use" do
    user = create :user
    user.confirm

    track_one = create :track
    track_two = create :track
    user.mentored_tracks = [track_one]

    sign_in! user

    get mentor_configure_path

    assert_select "form" do
      assert_select "input[name=?][checked=checked]", "track_id[#{track_one.id}]"
      assert_select "input[name=?]", "track_id[#{track_two.id}]"
    end
  end
end
