require 'test_helper'
require "webmock/minitest"

class Git::GithubProfileTest < ActiveSupport::TestCase
  test "provides access to underlying GitHub user" do
    setup_stubs!
    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal @stub_gh_user, profile.user
  end

  test "reads info from GitHub user" do
    setup_stubs!
    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal "dummy_avatar_url", profile.avatar_url
    assert_equal "A. Dummy Name", profile.name
    assert_equal "Me Coder.", profile.bio
    assert_equal "dummy_profile_url", profile.link_url
  end

  test "uses username if name is nil" do
    setup_stubs!
    @stub_gh_user = stub(
      login: @username,
      avatar_url: "dummy_avatar_url",
      name: nil,
      bio: "Me Coder.",
      html_url: "dummy_profile_url"
    )

    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal @username, profile.name
  end

  test "uses username if name is blank" do
    setup_stubs!
    @stub_gh_user = stub(
      login: @username,
      avatar_url: "dummy_avatar_url",
      name: "",
      bio: "Me Coder.",
      html_url: "dummy_profile_url"
    )

    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal @username, profile.name
  end

  test "seeds empty bio if blank" do
    setup_stubs!
    @stub_gh_user = stub(
      avatar_url: "dummy_avatar_url",
      name: "A. Dummy Name",
      html_url: "dummy_profile_url",
      bio: nil
    )

    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal "", profile.bio
  end

  test "raises an error when receiving a 404" do
    stub_request(:get, "https://api.github.com/users/user").to_return(status: 404)

    assert_raises Git::GithubProfile::NotFoundError do
      Git::GithubProfile.for_user("user")
    end
  end

  private

  def setup_stubs!
    @username = "dummy-user"
    @stub_gh_user = stub(
      login: @username,
      avatar_url: "dummy_avatar_url",
      name: "A. Dummy Name",
      bio: "Me Coder.",
      html_url: "dummy_profile_url"
    )
  end
end
