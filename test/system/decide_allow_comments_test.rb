require "application_system_test_case"

class DecideAllowCommentsTest < ApplicationSystemTestCase
  test "shows for unset users with published solutions" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    create :solution, user: @current_user, published_at: Time.current

    visit my_tracks_path
    assert_selector "#modal.decide-allow-comments"
  end

  test "does not show for unset users without published solutions" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    create :solution, user: @current_user, published_at: nil

    visit my_tracks_path
    refute_selector "#modal.decide-allow-comments"
  end

  test "does not show for set users" do
    sign_in!
    @current_user.update(default_allow_comments: false)
    create :solution, user: @current_user, published_at: Time.current

    visit my_tracks_path
    refute_selector "#modal.decide-allow-comments"
  end

  test "allows comments and updates existing" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    solution = create :solution, user: @current_user, published_at: Time.current, allow_comments: false

    visit my_tracks_path
    assert_selector "#modal.decide-allow-comments"

    within("#modal.decide-allow-comments") do
      click_on "Yes - allow comments"
    end

    refute_selector "#modal.decide-allow-comments"
    assert @current_user.reload.default_allow_comments
    assert solution.reload.allow_comments
  end

  test "denies comments" do
    sign_in!
    @current_user.update(default_allow_comments: nil)
    solution = create :solution, user: @current_user, published_at: Time.current, allow_comments: true

    visit my_tracks_path
    assert_selector "#modal.decide-allow-comments"

    within("#modal.decide-allow-comments") do
      click_on "No thanks"
    end

    refute_selector "#modal.decide-allow-comments"
    refute @current_user.reload.default_allow_comments
    refute solution.reload.allow_comments
  end
end
