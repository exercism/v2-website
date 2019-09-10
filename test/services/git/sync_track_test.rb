require_relative '../../test_helper'

class Git::SyncTracksTest < ActiveSupport::TestCase
  test "updates track metadata" do
    track = create(:track, active: false)

    Git::SyncTrack.(track)

    assert track.active?
  end

  test "updates exercise unlocked_by" do
    track = create(:track, active: false)
    slugs = create(:exercise, track: track)
    hello_world = create(:exercise,
                         track: track,
                         unlocked_by: slugs,
                         uuid: "4e2533dd-3af5-400b-869d-78140764d533")

    Git::SyncTrack.(track)

    hello_world.reload
    assert_nil hello_world.unlocked_by
  end

  test "pulls exercise title from problem specifications" do
    track = create(:track)

    Git::SyncTrack.(track)

    exercise = Exercise.last
    assert_equal "Hello World", exercise.title
  end
end
