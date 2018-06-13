require 'test_helper'

class CreateTeamInvitationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "creates team invitation" do
    inviter = create(:user)
    team = create(:team)

    CreateTeamInvitation.(team, inviter, "test@example.com")

    invite = TeamInvitation.last
    refute_nil invite, "Expected team invitation to be created"
    assert_equal inviter, invite.invited_by
    assert_equal "test@example.com", invite.email
    assert_equal team, invite.team
  end

  test "sends an email to a new user" do
    inviter = create(:user, name: "Leader")
    team = create(:team)

    perform_enqueued_jobs do
      CreateTeamInvitation.(team, inviter, "test@example.com")
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal "Leader has invited you to join Exercism", email.subject
    assert_equal "test@example.com", email.to[0]
    assert_includes email.text_part.decoded, "https://teams.exercism.io"
    assert_includes email.html_part.decoded, "https://teams.exercism.io"
  end
end
