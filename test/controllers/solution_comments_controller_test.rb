require 'test_helper'

class SolutionsCommentsControllerTest < ActionDispatch::IntegrationTest
  test "show should redirect to solution" do
    comment = create :solution_comment

    get solution_comment_path(comment.solution, comment)
    assert_redirected_to solution_path(comment.solution, anchor: "solution-comment-#{comment.id}")
  end
end
