require 'test_helper'

class HeartbeatMailerTest < ActionMailer::TestCase
  test "mentor_heartbeat - general" do
    user = create :user_mentor

    email = HeartbeatMailer.mentor_heartbeat(user, minimal_mentor_heartbeat_data, nil)
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] Weekly mentoring update", email.subject
  end

  test "mentor_heartbeat - welcome for new mentors" do
    user = create :user_mentor

    text = "Welcome to your first mentor Heartbeat. Each week we'll be sending a brief summary on the state of each track you're mentor. We'll also include some information on any changes or updates to the mentor side of Exercism that have occurred this week, and some inspiration from our community. If you have any thoughts or ideas on what you'd like to see here, please open an issue on GitHub."

    email = HeartbeatMailer.mentor_heartbeat(user, minimal_mentor_heartbeat_data, text)
    assert_body_includes email, text
    assert_text_includes email, text
  end

  def minimal_mentor_heartbeat_data
    {site: {}, tracks: [], num_solutions_mentored_by_user: 0}
  end
end

