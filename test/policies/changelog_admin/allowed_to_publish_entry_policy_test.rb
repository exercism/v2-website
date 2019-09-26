require "test_helper"

module ChangelogAdmin
  class AllowedToPublishEntryPolicyTest < ActiveSupport::TestCase
    test "allow admins to publish entries" do
      admin = create(:user, admin: true)

      assert AllowedToPublishEntryPolicy.allowed?(admin)
    end

    test "does not allow other admins to publish entries" do
      admin = create(:user, admin: false)

      refute AllowedToPublishEntryPolicy.allowed?(admin)
    end
  end
end
