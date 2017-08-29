require "test_helper"

class Git::ProblemSpecificationsTest < ActiveSupport::TestCase
  test "equal when repo urls are the same" do
    repo = Git::ProblemSpecifications.new("https://github.com/exercism/problem-specifications")
    another_repo = Git::ProblemSpecifications.new("https://github.com/exercism/problem-specifications")

    assert_equal repo, another_repo
  end

  test "unequal when repo urls are different" do
    repo = Git::ProblemSpecifications.new("https://github.com/exercism/problem-specifications")
    another_repo = Git::ProblemSpecifications.new("https://github.com/exercism/problem-specifications-v2")

    refute_equal repo, another_repo
  end
end
