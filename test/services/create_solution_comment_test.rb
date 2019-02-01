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
    assert_equal 1, solution.reload.num_comments
  end

  test "notifications work correctly" do
    solution_user = create :user, name: "solution user"
    other_user_1 = create :user, name: "other user 1"
    other_user_2 = create :user, name: "other user 2"
    solution = create :solution, user: solution_user

    content_1 = "foobar1"
    content_2 = "foobar2"
    content_3 = "foobar3"
    content_4 = "foobar4"

    #-----

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == solution_user &&
      args[1]         == :new_solution_comment_for_solution_user &&
      args[2].content == content_1
    end

    comment_1 = CreateSolutionComment.(solution, other_user_1, content_1)
    assert_equal 1, Notification.count
    assert_notification(solution, solution_user, :new_solution_comment_for_solution_user, comment_1)

    #-----

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == other_user_1 &&
      args[1]         == :new_solution_comment_for_other_commenter &&
      args[2].content == content_2
    end

    solution.reload
    comment_2 = CreateSolutionComment.(solution, solution_user, content_2)
    assert_equal 2, Notification.count
    assert_notification(solution, other_user_1, :new_solution_comment_for_other_commenter, comment_2)

    #-----

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == solution_user &&
      args[1]         == :new_solution_comment_for_solution_user &&
      args[2].content == content_3
    end

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == other_user_1 &&
      args[1]         == :new_solution_comment_for_other_commenter &&
      args[2].content == content_3
    end

    solution.reload
    comment_3 = CreateSolutionComment.(solution, other_user_2, content_3)
    assert_equal 4, Notification.count
    assert_notification(solution, solution_user, :new_solution_comment_for_solution_user, comment_3)
    assert_notification(solution, other_user_1, :new_solution_comment_for_other_commenter, comment_3)

    #-----

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == solution_user &&
      args[1]         == :new_solution_comment_for_solution_user &&
      args[2].content == content_4
    end

    DeliverEmail.expects(:call).once.with do |*args|
      args[0]         == other_user_2 &&
      args[1]         == :new_solution_comment_for_other_commenter &&
      args[2].content == content_4
    end

    solution.reload
    comment_4 = CreateSolutionComment.(solution, other_user_1, content_4)
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
