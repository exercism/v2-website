require 'test_helper'

class MentorNotificationsMailerTest < ActionMailer::TestCase
   test "new_discussion_post" do
    discussion_post = create :discussion_post
    user = discussion_post.iteration.solution.user
    user_track = create :user_track, user: user, track: discussion_post.iteration.solution.exercise.track
    mentor = create :user

    solution = discussion_post.solution
    exercise = solution.exercise

    email = MentorNotificationsMailer.new_discussion_post(mentor, discussion_post)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [mentor.email], email.to
    assert_equal "[Exercism Mentor Notification] New comment on #{exercise.track.title}/#{exercise.title} - #{solution.uuid[0,5]}", email.subject

    str = "A student you are mentoring (#{user.handle}) has posted"
    assert_body_includes email, str
    assert_text_includes email, str
  end

  test "new_discussion_post with anon handle" do
    handle = "foobar-ftw"
    discussion_post = create :discussion_post
    user = discussion_post.iteration.solution.user
    user_track = create :user_track, handle: handle, anonymous: true, user: user, track: discussion_post.iteration.solution.exercise.track

    mentor = create :user

    email = MentorNotificationsMailer.new_discussion_post(mentor, discussion_post)
    str = "A student you are mentoring (#{handle}) has posted"
    assert_body_includes email, str
    assert_text_includes email, str
    refute_body_includes email, user.handle
    refute_text_includes email, user.handle
  end

  test "new_iteration" do
    iteration = create :iteration
    user = iteration.solution.user
    user_track = create :user_track, user: user, track: iteration.solution.exercise.track
    mentor = create :user

    solution = iteration.solution
    exercise = solution.exercise

    email = MentorNotificationsMailer.new_iteration(mentor, iteration)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [mentor.email], email.to
    assert_equal "[Exercism Mentor Notification] New iteration on #{exercise.track.title}/#{exercise.title} - #{solution.uuid[0,5]}", email.subject

    str = "A student you are mentoring (#{user.handle}) has posted"
    assert_body_includes email, str
    assert_text_includes email, str
  end

  test "new_iteration with anon handle" do
    handle = "foobar-ftw"
    iteration = create :iteration
    user = iteration.solution.user
    user_track = create :user_track, handle: handle, anonymous: true, user: user, track: iteration.solution.exercise.track

    mentor = create :user

    email = MentorNotificationsMailer.new_iteration(mentor, iteration)
    str = "A student you are mentoring (#{handle}) has posted"
    assert_body_includes email, str
    assert_text_includes email, str
    refute_body_includes email, user.handle
    refute_text_includes email, user.handle
  end

  test "remind" do
    solution = create :solution
    exercise = solution.exercise
    user = solution.user
    user_track = create :user_track, user: user, track: exercise.track
    mentor = create :user

    email = MentorNotificationsMailer.remind(mentor, solution)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [mentor.email], email.to
    assert_equal "[Exercism Mentor Reminder] Action required on #{exercise.track.title}/#{exercise.title} - #{solution.uuid[0,5]}", email.subject

    str = %Q{since "#{user.handle}" last}
    assert_body_includes email, str
    assert_text_includes email, str
  end

  test "remind with anon handle" do
    handle = "foobar-ftw"
    solution = create :solution
    user = solution.user
    user_track = create :user_track, handle: handle, anonymous: true, user: user, track: solution.exercise.track

    mentor = create :user

    email = MentorNotificationsMailer.remind(mentor, solution)
    str = %Q{since "#{handle}" last}
    assert_body_includes email, str
    assert_text_includes email, str
    refute_body_includes email, user.handle
    refute_text_includes email, user.handle
  end

end
