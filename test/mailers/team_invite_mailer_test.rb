require 'test_helper'

class TeamInviteMailerTest < ActionMailer::TestCase
  test "new_user" do
    invite = create :team_invitation

    email = TeamInviteMailer.new_user(invite)
    assert_emails 1 do 
      email.deliver_now 
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [invite.email], email.to
    assert_equal "#{invite.inviter_name} has invited you to join their team on Exercism", email.subject
  end

  test "existing_user" do
    invite = create :team_invitation

    email = TeamInviteMailer.existing_user(invite)
    assert_emails 1 do 
      email.deliver_now 
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [invite.email], email.to
    assert_equal "[Exercism] #{invite.inviter_name} has invited you to join their team", email.subject
  end
end
