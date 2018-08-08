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
      assert_track_selected(track_one.id)
      assert_track_not_selected(track_two.id)
    end

    # User unclicks their track and cliks the other path
    # effectively switching which tracks they belong to
    put mentor_configure_path("track_id" => { track_two.id.to_s => true })
    get mentor_configure_path

    assert_select "form" do
      assert_track_not_selected(track_one.id)
      assert_track_selected(track_two.id)
    end
  end

  def assert_track_selected(track_id)
    assert_select "input[name=?][checked=checked]", "track_id[#{track_id}]"
  end

  def assert_track_not_selected(track_id)
    assert_select "input[name=?][checked=checked]", "track_id[#{track_id}]", false
  end
end
