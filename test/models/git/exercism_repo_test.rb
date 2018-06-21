require "test_helper"

class Git::ExercismRepoTest < ActiveSupport::TestCase
  test "check about works" do
    content = mock
    head = "SOME_HEAD_SHA"
    repo = Git::ExercismRepo.new("https://github.com/exercism/go")
    repo.expects(:head_commit).returns(head)
    repo.expects(:read_docs).with(head, "ABOUT.md").returns(content)
    assert_equal content, repo.about
  end

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
