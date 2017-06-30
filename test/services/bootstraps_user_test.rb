require 'test_helper'

class BootstrapsUserTest < ActiveSupport::TestCase
  test "creates auth token" do
    user = create :user
    BootstrapsUser.bootstrap(user)

    assert_equal 1, AuthToken.where(user_id: user.id).count
  end
end


