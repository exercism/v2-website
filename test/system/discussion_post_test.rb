require "application_system_test_case"

class DiscussionPostTest < ApplicationSystemTestCase
  test "user edits a discussion post" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user, independent_mode: false)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)
    iteration = create(:iteration, solution: solution)
    discussion_post = create(:discussion_post,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: user,
                             iteration: iteration)
    create(:discussion_post,
           content: "Test",
           html: "<p>Test</p>",
           iteration: iteration)

    sign_in!(user)
    visit my_solution_path(solution)
    click_on "Edit"
    fill_simple_mde "discussion_post_content", "Hey!"
    click_on "Save Changes"

    assert_text "Hey!"
    assert_text "(edited less than a minute ago)"
    discussion_post.reload
    assert_equal "Hello!", discussion_post.previous_content
  end

  test "user deletes a discussion post" do
    user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:user_track, track: track, user: user, independent_mode: false)
    exercise = create(:exercise, track: track)
    solution = create(:solution, user: user, exercise: exercise)
    iteration = create(:iteration, solution: solution)
    discussion_post = create(:discussion_post,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: user,
                             iteration: iteration)

    sign_in!(user)
    visit my_solution_path(solution)
    accept_confirm do
      click_on "Delete"
    end

    assert_text "This message has been deleted"
  end

  test "mentor edits a discussion post" do
    mentor = create(:user,
                    accepted_terms_at: Date.new(2016, 12, 25),
                    accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:track_mentorship, track: track, user: mentor)
    exercise = create(:exercise, track: track)
    solution = create(:solution, exercise: exercise)
    iteration = create(:iteration, solution: solution)
    create(:solution_mentorship, user: mentor, solution: solution)
    discussion_post = create(:discussion_post,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: mentor,
                             iteration: iteration)

    sign_in!(mentor)
    visit mentor_solution_path(solution)
    click_on "Edit"
    fill_simple_mde "discussion_post_content", "Hey!"
    click_on "Save Changes"

    assert_text "Hey!"
    assert_text "(edited less than a minute ago)"
    discussion_post.reload
    assert_equal "Hello!", discussion_post.previous_content
  end

  test "mentor deletes a discussion post" do
    mentor = create(:user,
                    accepted_terms_at: Date.new(2016, 12, 25),
                    accepted_privacy_policy_at: Date.new(2016, 12, 25))
    track = create(:track)
    create(:track_mentorship, track: track, user: mentor)
    exercise = create(:exercise, track: track)
    solution = create(:solution, exercise: exercise)
    iteration = create(:iteration, solution: solution)
    create(:solution_mentorship, user: mentor, solution: solution)
    discussion_post = create(:discussion_post,
                             content: "Hello!",
                             html: "<p>Hello!</p>",
                             user: mentor,
                             iteration: iteration)

    sign_in!(mentor)
    visit mentor_solution_path(solution)
    accept_confirm do
      click_on "Delete"
    end

    assert_text "This message has been deleted"
  end

  private

  def fill_simple_mde(id, value)
    script = <<~SCRIPT
      var textarea = $('textarea[id=#{id}]').nextAll('.CodeMirror')[0].CodeMirror;
      textarea.getDoc().setValue('#{value}');
    SCRIPT
    page.execute_script(script);
  end
end
