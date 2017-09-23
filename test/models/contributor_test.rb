require_relative '../test_helper'

class ContributorTest < ActiveSupport::TestCase
  FakeContribution = Struct.new(:github_id, :username, :avatar_url)

  test "a valid contributor" do
    assert Contributor.new(github_id: 1, github_username: 'alice').valid?
  end

  test "invalid without username" do
    refute Contributor.new(github_id: 1).valid?
  end

  test "invalid without github_id" do
    refute Contributor.new(github_id: 1).valid?
  end

  test "contributors have 0 contributions by default" do
    assert_equal 0, Contributor.new.num_contributions
  end
end
