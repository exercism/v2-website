require "test_helper"

module ChangelogAdmin
  class AllowedToDeleteEntryPolicyTest < ActiveSupport::TestCase
    test "allow admins to delete entries" do
      admin = create(:user, admin: true)
      user = create(:user)
      entry = create(:changelog_entry,
                     published_at: nil,
                     created_by: user)

      assert AllowedToDeleteEntryPolicy.allowed?(user: admin, entry: entry)
    end

    test "allow changelog admins to delete their own unpublished entries" do
      user = create(:user)
      entry = create(:changelog_entry, published_at: nil, created_by: user)

      assert AllowedToDeleteEntryPolicy.allowed?(user: user, entry: entry)
    end
  end
end
