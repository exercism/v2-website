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

  test "checks whether a user is an admin" do
    non_admin = create(:user)
    admin = create(:user)
    team = create(:team)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)
    create(:team_membership,
           user: admin,
           team: team,
           admin: true)

    assert team.admin?(admin)
    refute team.admin?(non_admin)
  end

  test "returns team admins" do
    non_admin = create(:user)
    admin = create(:user)
    team = create(:team, url_join_allowed: false)
    create(:team_membership,
           user: non_admin,
           team: team,
           admin: false)
    create(:team_membership,
           user: admin,
           team: team,
           admin: true)

    assert_equal [admin], team.admins
  end
end
