require "test_helper"

module ChangelogAdmin
  class AllowedToEditEntryPolicyTest < ActiveSupport::TestCase
    test "not allowed when entry has been published" do
      user = create(:user)
      entry = create(:changelog_entry,
                     published_at: Time.utc(2016, 12, 25),
                     created_by: user)

      refute AllowedToEditEntryPolicy.allowed?(user: user, entry: entry)
    end

    test "allow admins to edit entries of others" do
      admin = create(:user, admin: true)
      user = create(:user)
      entry = create(:changelog_entry,
                     published_at: nil,
                     created_by: user)

      assert AllowedToEditEntryPolicy.allowed?(user: admin, entry: entry)
    end
  end
end
