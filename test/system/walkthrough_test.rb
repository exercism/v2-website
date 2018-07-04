require "application_system_test_case"

class WalkthroughTest < ApplicationSystemTestCase
  test "shows walkthrough" do
    git_repo_cache = "#{Rails.root}/test/tmp/git_repo_cache"
    Git::RepoBase.
      stubs(:repo_base_dir).
      returns(git_repo_cache)
    Git::WebsiteContent.
      stubs(:repo_url).
      returns("file://#{Rails.root}/test/fixtures/website-copy")
    user = create(:user)
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    create(:user_track, user: user, track: track)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Begin Walk-Through"

    assert_text "Welcome to the Exercism installation guide!"

    FileUtils.rm_rf(git_repo_cache)
  end
end
