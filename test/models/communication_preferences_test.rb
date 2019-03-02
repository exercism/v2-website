require 'test_helper'

class CommunicationPreferencesTest < ActiveSupport::TestCase
  test "token is set" do
    token = 'the-foobar'
    SecureRandom.stubs(uuid: token)

    user = build :user
    user.save!

    assert_equal token, user.communication_preferences.token
  end
end
