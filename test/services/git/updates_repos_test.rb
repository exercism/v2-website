require 'test_helper'

class Git::UpdatesReposTest < ActiveSupport::TestCase
  test "creates repo update records to update repos" do
    track = create(:track, slug: "cpp")

    Git::UpdatesRepos.update

    refute_nil RepoUpdate.find_by(slug: "cpp")
    refute_nil RepoUpdate.find_by(slug: "problem-specifications")
    refute_nil RepoUpdate.find_by(slug: "website-copy")
  end
end
