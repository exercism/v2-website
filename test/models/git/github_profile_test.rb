require 'test_helper'

class Git::GithubProfileTest < ActiveSupport::TestCase

  def setup
    @username = "dummy-user"
    @stub_gh_user = stub(
      login: @username,
      avatar_url: "dummy_avatar_url",
      name: "A. Dummy Name",
      bio: "Me Coder.",
      html_url: "dummy_profile_url"
    )
  end

  test "provides access to underlying GitHub user" do
    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal @stub_gh_user, profile.user
  end

  test "reads info from GitHub user" do
    Octokit::Client.any_instance.expects(:user).with(@username).returns(@stub_gh_user)
    profile = Git::GithubProfile.for_user(@username)

    assert_equal "dummy_avatar_url", profile.avatar_url
    assert_equal "A. Dummy Name", profile.name
    assert_equal "Me Coder.", profile.bio
    assert_equal "dummy_profile_url", profile.link_url
  end

  test "uses username if name is nil" do
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
end
