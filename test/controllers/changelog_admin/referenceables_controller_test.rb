require "test_helper"

module ChangelogAdmin
  class ReferenceablesControllerTest < ActionDispatch::IntegrationTest
    test "allow searching by track" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      track = create(:track, title: "Ruby")

      sign_in!(user)
      get search_changelog_admin_referenceables_path(query: "Ru")

      assert_response :ok
      assert_equal(
        [
          {
            "id" => track.to_global_id.to_s,
            "title" => track.title
          }
        ],
        JSON.parse(response.body)
      )

      Flipper.disable(:changelog)
    end

    test "allow searching by exercise" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      track = create(:track, title: "Ruby")
      exercise = create(:exercise, title: "Hello", track: track)

      sign_in!(user)
      get search_changelog_admin_referenceables_path(query: "He")

      assert_response :ok
      assert_equal(
        [
          {
            "id" => exercise.to_global_id.to_s,
            "title" => "Ruby - Hello"
          }
        ],
        JSON.parse(response.body)
      )

      Flipper.disable(:changelog)
    end

    test "allow searching by exercise and track" do
      Flipper.enable(:changelog)
      user = create(:user, :onboarded, may_edit_changelog: true)
      track = create(:track, title: "Ruby")
      exercise = create(:exercise, title: "Hello", track: track)

      sign_in!(user)
      get search_changelog_admin_referenceables_path(query: "Ruby - He")

      assert_response :ok
      assert_equal(
        [
          {
            "id" => exercise.to_global_id.to_s,
            "title" => "Ruby - Hello"
          }
        ],
        JSON.parse(response.body)
      )

      Flipper.disable(:changelog)
    end
  end
end
