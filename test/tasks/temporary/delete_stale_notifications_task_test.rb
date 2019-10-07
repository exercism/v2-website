require "test_helper"

module Temporary
  class DeleteStaleNotificationsTaskTest < ActiveSupport::TestCase
    test "deletes notifications about deleted solutions" do
      stale = create(:notification,
                     about_type: "Solution",
                     about_id: 123)
      solution = create(:solution)
      active = create(:notification, about: solution)

      null_stream = File.open(File::NULL, "w")
      DeleteStaleNotificationsTask.(stream: null_stream)

      refute Notification.exists?(stale.id)
      assert Notification.exists?(active.id)
    end

    test "deletes notifications about deleted iterations" do
      stale = create(:notification,
                     about_type: "Iteration",
                     about_id: 123)
      iteration = create(:solution)
      active = create(:notification, about: iteration)

      null_stream = File.open(File::NULL, "w")
      DeleteStaleNotificationsTask.(stream: null_stream)

      refute Notification.exists?(stale.id)
      assert Notification.exists?(active.id)
    end
  end
end
