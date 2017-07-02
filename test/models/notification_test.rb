require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "read is false by default" do
    notification = Notification.create!(
      user: create(:user),
      content: "Fooobar",
      link: "http://baaaarfoo.com"
    )
    refute notification.read?
  end
end
