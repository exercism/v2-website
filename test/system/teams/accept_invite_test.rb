require 'application_system_test_case'

class Teams::AcceptInviteTest < ApplicationSystemTestCase
  test "user accepts invite with same email" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host

    user = create(:user, email: "test@example.com")
    team = create(:team, name: "Team A")
    create(:team_invitation, team: team, email: "test@example.com")

    sign_in!(user)
    visit teams_teams_path
    click_on "Accept"

    assert page.has_link?("Team A")
    assert page.has_no_content?("Pending Invitations")

    Capybara.app_host = original_host
  end

  test "user accepts invite with different email address" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host

    user = create(:user)
    team = create(:team, name: "Team A")
    invitation = create(:team_invitation, team: team)

    sign_in!(user)
    visit teams_invitation_path(invitation.token)
    click_on "Accept"

    assert page.has_link?("Team A")
    assert page.has_no_content?("Pending Invitations")
  end

  test "user accepts invite with different new user" do
    original_host = Capybara.app_host
    Capybara.app_host = SeleniumHelpers.teams_host

    email = "foooos@fooooos.com"
    user = create(:user, email: email)
    user.confirm

    team = create(:team, name: "Team A")
    invitation = create(:team_invitation, team: team)

    visit teams_invitation_path(invitation.token)

    # Redirected to log in. Move to sign up
    assert_selector "#log-in-page.lo-devise-page"
    fill_in "Email address", with: email
    fill_in "Password", with: FactoryBot.attributes_for(:user)[:password]
    within "form" do
      click_on "Log in"
    end

    assert_selector "body.namespace-teams.controller-invitations.action-show"
    click_on "Accept"

    assert page.has_link?("Team A")
    assert page.has_no_content?("Pending Invitations")

    Capybara.app_host = original_host
  end
end
