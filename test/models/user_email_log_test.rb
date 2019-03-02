require 'test_helper'

class UserEmailLogTest < ActiveSupport::TestCase
  test "finds or creates" do
    user = create :user
    email_log_1 = UserEmailLog.for_user(user)
    email_log_2 = UserEmailLog.for_user(user)

    assert email_log_1.persisted?
    assert_equal user, email_log_1.user
    assert_equal email_log_1, email_log_2
  end
  # test "the truth" do
  #   assert true
  # end
end
