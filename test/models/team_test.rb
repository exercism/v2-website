require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "slugs" do
    name = "Foo Bar"
    uuid_part = "1231"
    uuid = "#{uuid_part}-34534-65756-234"
    SecureRandom.stubs(uuid: uuid)

    assert_equal "foo-bar", create(:team, name: name).slug
    assert_equal "foo-bar-#{uuid_part}", create(:team, name: name).slug
  end
end
