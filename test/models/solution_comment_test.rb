require 'test_helper'

class SolutionCommentTest < ActiveSupport::TestCase
  test "emoji's don't blow up" do
    create :solution_comment, 
      content: "Had to peek at other solutions to realize my strategy for shouting was unnecessarily complicated 🙂",
      html: "<p>Had to peek at other solutions to realize my strategy for shouting was unnecessarily complicated 🙂</p>"
  end
end
