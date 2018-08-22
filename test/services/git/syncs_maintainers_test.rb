require 'test_helper'

class Git::SyncsMaintainersTest < ActiveSupport::TestCase
  setup do
    @track = create :track
    stub_gh_user = stub(
      avatar_url: "dummy_url",
      name: "A. Dummy Name",
      bio: "Me Coder.",
      link_url: "http://github/profile-link"
    )
    Git::GithubProfile.stubs(for_user: stub_gh_user)
  end

  def expecting_two_user_lookups_on_github
    gh_user1 = stub(
      name: "Jo B",
      avatar_url: "http://avatar-service/jo1",
      bio: "Coding Geek",
      link_url: "http://github/profile-link"
    )
    gh_user2 = stub(
      name: "Joe B",
      avatar_url: "http://avatar-service/jo2",
      bio: "Software Geek",
      link_url: "http://github/profile-link"
    )

    Git::GithubProfile.expects(:for_user).with("jo1").returns(gh_user1)
    Git::GithubProfile.expects(:for_user).with("jo2").returns(gh_user2)
  end

  test "sanity check that maintainers are seeded empty" do
    assert_empty @track.maintainers
  end

  test "supports undefined maintainers" do
    Git::SyncsMaintainers.sync!(@track, {})
    assert_empty @track.maintainers
  end

  test "ignores nil config" do
    Git::SyncsMaintainers.sync!(@track, nil)
    assert_empty @track.maintainers
  end

  test "supports nil maintainers" do
    Git::SyncsMaintainers.sync!(@track, { maintainers: nil })
    assert_empty @track.maintainers
  end

  test "supports empty maintainers" do
    Git::SyncsMaintainers.sync!(@track, { maintainers: [] })
    assert_empty @track.maintainers
  end

  test "alumnus field defaults to 'alumnus' if true" do
    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          name: "Joanne Bloggs",
          alumnus: true
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_equal 1, @track.maintainers.size
    assert_equal false, @track.maintainers.first.active?
    assert_equal "alumnus", @track.maintainers.first.alumnus
  end

  test "alumnus field defaults to nil if false" do
    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          name: "Joanne Bloggs",
          alumnus: false
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_nil @track.maintainers.first.alumnus
  end

  test "drops maintainers with no gh_user or show_on_website" do
    maintainers_config = {
      maintainers: [
        {
          show_on_website: true,
          name: "Joanne Bloggs",
          bio: "I'm a geek",
          link_text: "My Website",
          link_url: "http://example.com/jo",
          avatar_url: "http://example.com/jo/avatar"
        },
        {
          github_username: "example",
          name: "Joe Bloggs",
          bio: "I'm a geek",
          link_text: "My Website",
          link_url: "http://example.com/jo",
          avatar_url: "http://example.com/jo/avatar"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)
    assert_empty @track.maintainers
  end

  test "drops maintainers that are not set to show_on_website" do
    maintainers_config = {
      maintainers: [
        {
          github_username: "example_jb1",
          name: "Joanne Bloggs",
          show_on_website: false
        },
        {
          github_username: "example_jb2",
          name: "Joseph Bloggs",
          show_on_website: true
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)
    assert_equal 1, @track.maintainers.size
  end

  test "adds single maintainer and populates all fields" do
    maintainers_config = {
      maintainers: [
        {
          github_username: "example",
          show_on_website: true,
          name: "Joanne Bloggs",
          bio: "I'm a geek",
          link_text: "My Website",
          link_url: "http://example.com/jo",
          avatar_url: "http://example.com/jo/avatar"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_equal 1, @track.maintainers.size

    m = @track.maintainers.first

    assert_equal "example", m.github_username
    assert_equal "Joanne Bloggs", m.name
    assert_equal "I'm a geek", m.bio
    assert_equal "http://example.com/jo", m.link_url
    assert_equal "http://example.com/jo/avatar", m.avatar_url
    assert_equal "My Website", m.link_text

    assert m.active?
  end

  test "adds an extra maintainer" do
    create :maintainer, track: @track, github_username: "jo1", name: "Joanne Bloggs"

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          name: "Joanne Bloggs"
        },
        {
          github_username: "jo2",
          show_on_website: true,
          name: "Joseph Bloggs"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_equal 2, @track.maintainers.size

    names = @track.maintainers.pluck(:name)

    assert_includes names, "Joanne Bloggs"
    assert_includes names, "Joseph Bloggs"
  end

  test "updates extra maintainer" do
    create :maintainer, track: @track, github_username: "jo1", name: "Joanne Bloggs"

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          name: "Joanne MIDDLENAME Bloggs"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_equal 1, @track.maintainers.size
    assert_equal "Joanne MIDDLENAME Bloggs", @track.maintainers.first.name
  end

  test "removes missing and inactive maintainers" do
    create :maintainer, track: @track, github_username: "jo1", name: "Joanne Bloggs"
    create :maintainer, track: @track, github_username: "jo2", name: "Joseph Bloggs"

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: false,
          name: "Joanne Bloggs"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    assert_empty @track.maintainers
  end

  test "avatar_url defaults to your GitHub avatar if null or absent" do
    expecting_two_user_lookups_on_github

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          name: "Joanne Bloggs"
        },
        {
          github_username: "jo2",
          show_on_website: true,
          name: "Joseph Bloggs",
          avatar_url: nil
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    @maintainers = @track.maintainers
    assert_equal 2, @maintainers.size
    assert_equal "http://avatar-service/jo1", @maintainers.first.avatar_url
    assert_equal "http://avatar-service/jo2", @maintainers.second.avatar_url
  end

  test "name defaults to whatever your public display name on GitHub is" do
    expecting_two_user_lookups_on_github

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true
        },
        {
          github_username: "jo2",
          show_on_website: true,
          name: "Joseph Bloggs"
        }
      ]
    }
    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    @maintainers = @track.maintainers
    assert_equal 2, @maintainers.size
    assert_equal "Jo B", @maintainers.first.name
    assert_equal "Joseph Bloggs", @maintainers.second.name
  end

  test "If bio is null or absent, it defaults to your public GitHub bio" do
    expecting_two_user_lookups_on_github

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          bio: nil
        },
        {
          github_username: "jo2",
          show_on_website: true,
        }
      ]
    }

    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    @maintainers = @track.maintainers
    assert_equal 2, @maintainers.size
    assert_equal "Coding Geek", @maintainers.first.bio
    assert_equal "Software Geek", @maintainers.second.bio
  end

  test "Link has no default, if absent we will show a link to your GitHub profile." do
    expecting_two_user_lookups_on_github

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          link_url: nil
        },
        {
          github_username: "jo2",
          show_on_website: true,
        }
      ]
    }

    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    @maintainers = @track.maintainers
    assert_equal 2, @maintainers.size
    assert @maintainers.first.link_url.nil?
    assert_equal "http://github/profile-link", @maintainers.second.link_url
  end

  test "Link text uses the link_url if not specified" do
    expecting_two_user_lookups_on_github

    maintainers_config = {
      maintainers: [
        {
          github_username: "jo1",
          show_on_website: true,
          link_url: "http://example.com/humpty-dumpty"
        },
        {
          github_username: "jo2",
          show_on_website: true,
          link_url: "http://example.com/humpty-dumpty",
          link_text: "humpty-dumpty"
        }
      ]
    }

    Git::SyncsMaintainers.sync!(@track, maintainers_config)

    @maintainers = @track.maintainers
    assert_equal 2, @maintainers.size

    assert_equal "http://example.com/humpty-dumpty", @maintainers.first.link_url
    assert_equal "http://example.com/humpty-dumpty", @maintainers.first.link_text

    assert_equal "http://example.com/humpty-dumpty", @maintainers.second.link_url
    assert_equal "humpty-dumpty", @maintainers.second.link_text
  end
end
