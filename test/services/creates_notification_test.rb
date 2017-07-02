require 'test_helper'

class CreatesNotificationTest < ActiveSupport::TestCase
  test "creates with about" do
    user = create :user
    content = "foobar"
    link = "http://barfoo.com"
    about = create :solution

    notification = CreatesNotification.create!(user, content, link, about: about)

    assert notification.persisted?
    assert_equal notification.user, user
    assert_equal notification.content, content
    assert_equal notification.link, link
    assert_equal notification.about, about
  end

  test "creates without about" do
    user = create :user
    content = "foobar"
    link = "http://barfoo.com"

    notification = CreatesNotification.create!(user, content, link)

    assert notification.persisted?
    assert_equal notification.user, user
    assert_equal notification.content, content
    assert_equal notification.link, link
    assert_nil notification.about
  end
end

