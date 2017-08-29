require 'test_helper'

class RepoUpdateTest < ActiveSupport::TestCase
  test "validates presence of slug" do
    repo_update = build_stubbed(:repo_update)

    assert repo_update.valid?

    repo_update.slug = ""

    refute repo_update.valid?
  end
end
