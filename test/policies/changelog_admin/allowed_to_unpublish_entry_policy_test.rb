require "test_helper"

module ChangelogAdmin
  class AllowedToUnpublishEntryPolicyTest < ActiveSupport::TestCase
    test "allow admins to unpublish entries" do
      admin = create(:user, admin: true)
      entry = create(:changelog_entry, published_at: Time.utc(2016, 12, 25))

      assert AllowedToUnpublishEntryPolicy.allowed?(user: admin, entry: entry)
    end

    test "does not allow other admins to unpublish entries" do
      admin = create(:user, admin: false)
      entry = create(:changelog_entry, published_at: Time.utc(2016, 12, 25))

      refute AllowedToUnpublishEntryPolicy.allowed?(user: admin, entry: entry)
    end

    test "does not allow admins to unpublish unpublished entries" do
      admin = create(:user, admin: true)
      entry = create(:changelog_entry, published_at: nil)

      refute AllowedToUnpublishEntryPolicy.allowed?(user: admin, entry: entry)
    end
  end
end
