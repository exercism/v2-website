require 'test_helper'

class CreateSolutionCommentTest < ActiveSupport::TestCase
  test "creates correctly" do
    solution = create :solution
    user = create :user
    content = "foobar"
    html = "<p>foobar</p>"

    comment = CreateSolutionComment.(solution, user, content)

    assert comment.persisted?
    assert_equal solution, comment.solution
    assert_equal user, comment.user
    assert_equal content, comment.content
    assert_equal html, comment.html.strip
  end

  test "notifications work correctly" do
    solution_user = create :user
    other_user_1 = create :user
    other_user_2 = create :user
    solution = create :solution, user: solution_user

    comment_1 = CreateSolutionComment.(solution, other_user_1, "foobar")
    assert_equal 1, Notification.count
    assert_notification(solution, solution_user, :new_solution_comment_for_solution_user, comment_1)

    solution.reload
    comment_2 = CreateSolutionComment.(solution, solution_user, "foobar2")
    assert_equal 2, Notification.count
    assert_notification(solution, other_user_1, :new_solution_comment_for_other_commenter, comment_2)

    solution.reload
    comment_3 = CreateSolutionComment.(solution, other_user_2, "foobar3")
    assert_equal 4, Notification.count
    assert_notification(solution, solution_user, :new_solution_comment_for_solution_user, comment_3)
    assert_notification(solution, other_user_1, :new_solution_comment_for_other_commenter, comment_3)

    solution.reload
    comment_4 = CreateSolutionComment.(solution, other_user_1, "foobar4")
    assert_equal 6, Notification.count
    assert_notification(solution, solution_user, :new_solution_comment_for_solution_user, comment_4)
    assert_notification(solution, other_user_2, :new_solution_comment_for_other_commenter, comment_4)
  end

  def assert_notification(solution, user, type, comment)
    assert Notification.where(
      about: solution,
      user: user,
      type: type,
      link: Rails.application.routes.url_helpers.solution_url(solution, anchor: "comment-#{comment}"),
      trigger: comment
    ).exists?
  end
end
