require "test_helper"

class ChangelogEntryTest < ActiveSupport::TestCase
  test "#publish! sets the published_at time" do
    time = Time.utc(2016, 12, 25)
    entry = create(:changelog_entry)

    entry.publish!(time)

    assert_equal time, entry.published_at
  end
end
