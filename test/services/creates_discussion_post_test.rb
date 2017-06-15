require 'test_helper'

class CreatesDiscussionPostTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    iteration = create :iteration
    user = iteration.solution.user
    content = "foobar"

    post = CreatesDiscussionPost.create!(iteration, user, content)

    assert post.persisted?
    assert_equal post.iteration, iteration
    assert_equal post.user, user
    assert_equal post.content, content
  end
end
