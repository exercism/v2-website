require "test_helper"

class Git::ExercismRepoTest < ActiveSupport::TestCase
  test "equal when repo urls are the same" do
    repo = Git::ExercismRepo.new("https://github.com/exercism/go")
    another_repo = Git::ExercismRepo.new("https://github.com/exercism/go")

    assert_equal repo, another_repo
  end

  test "unequal when repo urls are different" do
    repo = Git::ExercismRepo.new("https://github.com/exercism/go")
    another_repo = Git::ExercismRepo.new("https://github.com/exercism/cpp")

    refute_equal repo, another_repo
  end
end
