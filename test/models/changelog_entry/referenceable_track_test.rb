require "test_helper"

class ChangelogEntry::ReferenceableTrackTest < ActiveSupport::TestCase
  test "#twitter_account returns track twitter account" do
    track = create(:track, slug: "ruby")
    referenceable = ChangelogEntry::ReferenceableTrack.new(track)

    assert_equal TwitterAccount.find(:ruby), referenceable.twitter_account
  end
end
