require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test "accepting_new_students?" do
    create_solution = ->(track) do
      s = create :solution,
        user: create(:user, current_sign_in_at: Time.now),
        exercise: create(:exercise, track: track, core: true),
        mentoring_requested_at: Time.now - 1.week
      create :iteration, solution: s
    end

    # If a track has <10 solutions, always return true
    track = create :track, median_wait_time: 2.years
    9.times { create_solution.call(track) }

    # Under 1 week
    track = create :track, median_wait_time: 604799
    10.times { create_solution.call(track) }
    assert track.accepting_new_students?

    # Over 1 week
    track = create :track, median_wait_time: 604801
    10.times { create_solution.call(track) }
    refute track.accepting_new_students?
  end

  test "research_track?" do
    refute create(:track, slug: "ruby").research_track?
    assert create(:track, slug: "research_123").research_track?
  end

  test "#editor_config merges language with track editor config" do
    track = create(:track)
    track.repo = stub(editor_config: { indent_size: 4 })
    track.editor_language = "ruby"

    assert_equal({ language: "ruby", indent_size: 4 }, track.editor_config)
  end

  test "#editor_language returns language from config" do
    ruby = create(:track, slug: "ruby")
    go = create(:track, slug: "go")

    assert_equal "ruby", ruby.editor_language
    assert_equal "golang", track.editor_language
  end

  test "#editor_language returns slug when there is no config" do
    track = create(:track, slug: "ruby")

    assert_equal "ruby", track.editor_language
  end
end
