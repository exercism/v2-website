require_relative "./test_case"

class Teams::SolutionDiscussionTest < Teams::TestCase
  test "user comments on a solution and code is highlighted" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set(
      <<~TEXT
        ```ruby
        1+1
        ```
      TEXT
    )
    click_on "Comment"

    within(".widget-discussion-post") do
      assert_selector "pre.language-ruby", text: "1+1"
    end
  end

  test "comment preview parses markdown and highlights code" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set(
      <<~TEXT
        **Hello**
        ```ruby
        1+1
        ```
      TEXT
    )
    find(".preview-tab").click

    within(".preview-area") do
      assert_selector "strong", text: "Hello"
      assert_selector "pre.language-ruby", text: "1+1"
    end
  end

  test "textarea is cleared after submission" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set("Hello, world!")
    click_on "Comment"

    wait_for_ajax
    assert_empty find(".new-editable-text textarea").value
  end

  test "preview area is cleared after submission" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set("Hello, world!")
    find(".preview-tab").click
    click_on "Comment"

    assert_selector ".preview-area", text: ""
  end

  test "draft is cleared after submission" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set("Hello, world!")
    find(".preview-tab").click
    click_on "Comment"
    visit teams_team_solution_path(team, solution)

    refute_text "Draft saved"
  end

  test "comment is saved as draft" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)
    find(".new-editable-text textarea").set("Hello, world!")
    visit teams_team_solution_path(team, solution)

    assert_text "Draft saved"
    assert_equal "Hello, world!", find(".new-editable-text textarea").value
  end

  test "draft isn't saved for an empty comment" do
    user = create(:user, :onboarded)
    team = create(:team)
    create(:team_membership, team: team, user: user)
    solution = create(:team_solution, team: team, user: user)
    create(:iteration, solution: solution)

    sign_in!(user)
    visit teams_team_solution_path(team, solution)

    refute_text "Draft saved"
  end

  private

  def wait_for_ajax
    sleep(Capybara.default_max_wait_time)
  end
end
