require 'test_helper'
require 'webmock/minitest'

class MakeUserAMentorTest < ActiveSupport::TestCase
  test "makes user a mentor of the relevant track" do
    user = create :user
    solution = create :solution, user: user
    create :iteration, solution: solution
    track = create :track
    create :track

    stub_request(:post, "https://dev.null.exercism.io")
    MakeUserAMentor.(user, track.id)

    user.reload
    assert user.is_mentor?
    assert_equal [track], user.mentored_tracks
  end

  test "invites to Slack" do
    user = create :user
    solution = create :solution, user: user
    create :iteration, solution: solution

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
