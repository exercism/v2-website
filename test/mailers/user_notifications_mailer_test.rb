require 'test_helper'

class UserNotificationsMailerTest < ActionMailer::TestCase
   test "new_discussion_post" do
    discussion_post = create :discussion_post
    user = discussion_post.iteration.solution.user
    mentor = discussion_post.user

    solution = discussion_post.solution
    exercise_title = solution.exercise.title
    track_title = solution.track.title

    email = UserNotificationsMailer.new_discussion_post(user, discussion_post)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] A mentor has commented on your solution to #{track_title}/#{exercise_title}", email.subject
  end

   test "solution_approved" do
    solution = create :solution
    user = solution.user
    mentor = solution.approved_by

    exercise_title = solution.exercise.title
    track_title = solution.track.title

    email = UserNotificationsMailer.solution_approved(user, solution)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] A mentor has approved your solution to #{track_title}/#{exercise_title}", email.subject
  end

  test "remind_about_solution with unapproved solution" do
    track = create :track, title: "Ruby"
    exercise = create :exercise, title: "Bob", track: track
    solution = create :solution, exercise: exercise
    user = solution.user

    email = UserNotificationsMailer.remind_about_solution(user, solution, [])

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] Don't forget to continue your Exercism exercise", email.subject

    assert_body_includes email, "This is a friendly reminder that a mentor has posted a comment on your solution to Bob on the Ruby Track."
    assert_body_includes email, "You can review the comment here."

    assert_text_includes email, "This is a friendly reminder that a mentor has posted a comment on your solution to Bob on the Ruby Track."
    assert_text_includes email, "You can review the comment here:"
  end

  test "remind_about_solution with approved solution" do
    track = create :track, title: "Ruby"
    exercise = create :exercise, title: "Bob", track: track
    solution = create :solution, exercise: exercise, approved_by: create(:user)
    user = solution.user

    email = UserNotificationsMailer.remind_about_solution(user, solution, [])

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] Don't forget to continue your Exercism exercise", email.subject

    assert_body_includes email, "This is a friendly reminder that a mentor has approved your solution to Bob on the Ruby Track."
    assert_body_includes email, "You can complete the exercise here."

    assert_text_includes email, "This is a friendly reminder that a mentor has approved your solution to Bob on the Ruby Track."
    assert_text_includes email, "You can complete the exercise here:"
  end

  test "remind_about_solution with other solutions" do
    track = create :track, title: "Ruby"
    exercise = create :exercise, title: "Bob", track: track
    solution = create :solution, exercise: exercise
    other_solution_1 = create :solution, exercise: create(:exercise, title: "Two Fer")
    other_solution_2 = create :solution, exercise: create(:exercise, title: "High Score"), approved_by: create(:user)
    user = solution.user

    email = UserNotificationsMailer.remind_about_solution(user, solution, [other_solution_1, other_solution_2])

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] Don't forget to continue your Exercism exercise", email.subject

    assert_body_includes email, "You also have 2 other solutions that you can proceed with:"
    assert_body_includes email, "Two Fer on the Ruby Track"
    assert_body_includes email, "High Score on the Ruby Track (approved)"

    assert_text_includes email, "You also have 2 other solutions that you can proceed with:"
    assert_text_includes email, "Two Fer on the Ruby Track"
    assert_text_includes email, "High Score on the Ruby Track (approved)"
  end

end
