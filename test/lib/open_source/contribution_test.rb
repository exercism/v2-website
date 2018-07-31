require 'minitest/autorun'
require_relative '../../../lib/open_source'

class OpenSourceContributionTest < Minitest::Test
  def test_pushed_to_non_default_branch
    contribution = OpenSource::Contribution.new(fixture('push_event.to_non_default_branch'))

    refute contribution.complete?
  end

  def test_pr_merged_to_non_default_master
    contribution = OpenSource::Contribution.new(fixture('push_event.to_non_default_master'))

    refute contribution.complete?
  end

  def test_pr_merged_to_default_master
    contribution = OpenSource::Contribution.new(fixture('push_event.to_default_master'))

    assert contribution.complete?
    assert_equal 'carlos', contribution.username
    assert_equal 3, contribution.github_id
    assert_equal 'https://example.com/carlos.png', contribution.avatar_url
  end

  def test_pr_merged_to_non_standard_default
    contribution = OpenSource::Contribution.new(fixture('push_event.to_non_standard_default'))

    assert contribution.complete?
    assert_equal 'eu-jin', contribution.username
    assert_equal 5, contribution.github_id
    assert_equal 'https://example.com/eu-jin.png', contribution.avatar_url
  end

  private

  def fixture(name)
    JSON.parse(File.read(File.absolute_path('../../../fixtures/contributions/%s.json' % name, __FILE__)))
  end
end
