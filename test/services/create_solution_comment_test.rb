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
end
