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

  test "add a contribution for a new contributor" do
    contribution = FakeContribution.new(100, 'alice', 'alice.png')

    contributor = Contributor.with_contribution(contribution)
    assert_equal 100, contributor.github_id
    assert_equal 'alice', contributor.github_username
    assert_equal 'alice.png', contributor.avatar_url
    assert_equal 1, contributor.num_contributions
  end

  test "add a contribution for an existing contributor" do
    attributes = {
      github_username: 'alice',
      github_id: 100,
      avatar_url: 'alice.png',
      num_contributions: 1,
    }
    contributor = Contributor.create!(attributes)
    contribution = FakeContribution.new(100, 'alice', 'alice.png')

    contributor = Contributor.with_contribution(contribution)
    assert_equal 100, contributor.github_id
    assert_equal 'alice', contributor.github_username
    assert_equal 'alice.png', contributor.avatar_url
    assert_equal 2, contributor.num_contributions
  end

  test "add a contribution for an existing contributor with new user data" do
    attributes = {
      github_username: 'alice',
      github_id: 100,
      avatar_url: 'alice.png',
      num_contributions: 1,
    }
    contributor = Contributor.create!(attributes)
    contribution = FakeContribution.new(100, 'allison', 'allison.png')

    contributor = Contributor.with_contribution(contribution)
    assert_equal 100, contributor.github_id
    assert_equal 'allison', contributor.github_username
    assert_equal 'allison.png', contributor.avatar_url
    assert_equal 2, contributor.num_contributions
  end
end
