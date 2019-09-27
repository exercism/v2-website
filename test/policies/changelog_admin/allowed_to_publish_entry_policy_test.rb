require "test_helper"

module ChangelogAdmin
  class AllowedToPublishEntryPolicyTest < ActiveSupport::TestCase
    test "allow admins to publish entries" do
      admin = create(:user, admin: true)
      entry = create(:changelog_entry)

      assert AllowedToPublishEntryPolicy.allowed?(user: admin, entry: entry)
    end

    test "does not allow other admins to publish entries" do
      admin = create(:user, admin: false)
      entry = create(:changelog_entry)

      refute AllowedToPublishEntryPolicy.allowed?(user: admin, entry: entry)
    end

    test "does not allow other admins to publish published entries" do
      admin = create(:user, admin: true)
      entry = create(:changelog_entry, published_at: Time.utc(2016, 12, 25))

      refute AllowedToPublishEntryPolicy.allowed?(user: admin, entry: entry)
    end
  end
end
