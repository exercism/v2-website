require 'test_helper'

class SolutionsCommentsControllerTest < ActionDispatch::IntegrationTest
  test "show should redirect to solution" do
    comment = create :solution_comment

    get solution_comment_path(comment.solution, comment)
    assert_redirected_to solution_path(comment.solution, anchor: "solution-comment-#{comment.id}")
  end

  test "prevents forbidden users from commenting" do
    user = create(:user, :onboarded)
    solution = create(:solution)
    AllowedToCommentPolicy.stubs(:allowed?).returns(false)

    sign_in!(user)
    post solution_comments_path(solution),
      params: {
        solution_comment: {
          content: "Forbidden comment"
        }
      }

    assert_response :unprocessable_entity
  end
end
