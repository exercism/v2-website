require 'test_helper'

class CreateNotificationTest < ActiveSupport::TestCase
  %i{
    new_discussion_post
    new_discussion_post_for_mentor
  }.each do |type|
    test "type: #{type}" do
      notification = CreateNotification.(create(:user), type, "a", "b")
      assert notification.persisted?
    end
  end

  test "creates with about" do
    user = create :user
    type = 'new_discussion_post'
    content = "foobar"
    link = "http://barfoo.com"
    about = create :solution

    notification = CreateNotification.(user, type, content, link, about: about)

    assert notification.persisted?
    assert_equal notification.user, user
    assert_equal notification.type, type
    assert_equal notification.content, content
    assert_equal notification.link, link
    assert_equal notification.about, about
  end

  test "creates without about" do
    user = create :user
    type = 'new_discussion_post'
    content = "foobar"
    link = "http://barfoo.com"

    notification = CreateNotification.(user, type, content, link)

    assert notification.persisted?
    assert_equal notification.user, user
    assert_equal notification.type, type
    assert_equal notification.content, content
    assert_equal notification.link, link
    assert_nil notification.about
  end

  test "raises with invalid type" do
    assert_raises CreateNotification::UnknownNotificationTypeError do
      CreateNotification.(nil, :foobar, nil, nil)
    end
  end
end
