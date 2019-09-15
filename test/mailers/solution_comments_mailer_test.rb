require 'test_helper'

class SolutionCommentsMailerTest < ActionMailer::TestCase
   test "new_comment_for_solution_user" do
    comment = create :solution_comment
    user = create :user

    solution = comment.solution
    exercise_title = solution.exercise.title
    track_title = solution.track.title

    email = SolutionCommentsMailer.new_comment_for_solution_user(user, comment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to
    assert_equal "[Exercism] Someone has commented on your solution to #{track_title}/#{exercise_title}", email.subject
  end

  test "new_comment_for_other_commenter" do
    comment = create :solution_comment
    user = create :user

    solution = comment.solution
    exercise_title = solution.exercise.title
    track_title = solution.track.title

    email = SolutionCommentsMailer.new_comment_for_other_commenter(user, comment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["hello@mail.exercism.io"], email.from
    assert_equal ["hello@exercism.io"], email.reply_to
    assert_equal [user.email], email.to

    solution_user_handle = solution.user.handle_for(solution.exercise.track)
    assert_equal "[Exercism] Someone else has commented on #{solution_user_handle}'s solution to #{track_title}/#{exercise_title}", email.subject
  end
end
