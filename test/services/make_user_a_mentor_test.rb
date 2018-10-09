require 'test_helper'

class MakeUserAMentorTest < ActiveSupport::TestCase
  test "makes user a mentor of the relevant track" do
    user = create :user
    track = create :track
    create :track

    RestClient.stubs(:post)
    MakeUserAMentor.(user, track.id)

    user.reload
    assert user.is_mentor?
    assert_equal [track], user.mentored_tracks
  end

  test "invites to Slack" do
    user = create :user

    RestClient.expects(:post).with(
      "https://dev.null.exercism.io",
      {
        email: user.email,
        token: Rails.application.secrets.slack_api_token,
        set_active: 'true'
      }
    )
    MakeUserAMentor.(user, create(:track).id)
  end
end
