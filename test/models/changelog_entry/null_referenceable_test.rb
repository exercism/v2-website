require "test_helper"

class ChangelogEntry::NullReferenceableTest < ActiveSupport::TestCase
  test "#twitter_account returns main twitter account" do
    assert_equal(
      TwitterAccount.find(:main),
      ChangelogEntry::NullReferenceable.new.twitter_account
    )
  end
end
