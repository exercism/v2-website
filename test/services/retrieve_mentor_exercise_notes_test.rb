require "test_helper"

class RetrieveMentorExerciseNotesTest < ActiveSupport::TestCase
  test "html is retreived correctly" do
    skip
    track = create :track
    exercise = create :exercise, track: track
    html = RetrieveMentorExerciseNotes.(track, exercise)
    assert_equal "foo", html
  end
end
