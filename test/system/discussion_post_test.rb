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
    click_on "Update"

    assert_text "Hey!"
    assert_text "(edited)"
    discussion_post.reload
    assert_equal "Hello!", discussion_post.previous_content
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
