require "test_helper"

class ChangelogEntry::GeneralReferenceableTest < ActiveSupport::TestCase
  test "#twitter_account returns main twitter account" do
    assert_equal(
      TwitterAccount.find(:main),
      ChangelogEntry::GeneralReferenceable.new.twitter_account
    )
  end
end
