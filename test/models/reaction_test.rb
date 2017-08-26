require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  test "emoji's don't blow up" do
    create :reaction, comment: "Had to peek at other solutions to realize my strategy for shouting was unnecessarily complicated 🙂"
  end
end
