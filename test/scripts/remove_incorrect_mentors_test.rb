require 'test_helper'

class RemoveIncorrectMentorsTest < ActiveSupport::TestCase
  test "it removes the correct ones" do
    # Delete on Sept 1st 2018
    skip "Kept for posterity"

    Timecop.freeze do
      earlier = Time.now - 20.seconds
      earlier_plus_one_sec = earlier + 1.second
      now = Time.now
      alice = create :user
      jon = create :user
      dave = create :user

      ruby = create :track
      python = create :track
      cpp = create :track

      create :user_track, user: alice, track: ruby, created_at: earlier
      create :user_track, user: alice, track: python, created_at: earlier
      create :user_track, user: alice, track: cpp, created_at: earlier

      create :user_track, user: jon, track: ruby, created_at: earlier
      create :user_track, user: jon, track: python, created_at: earlier

      create :user_track, user: dave, track: ruby, created_at: earlier

      keeps = []
      removes = []
      keeps << create(:track_mentorship, user: alice, track: ruby, created_at: now)
      removes << create(:track_mentorship, user: alice, track: python, created_at: earlier)
      removes << create(:track_mentorship, user: alice, track: cpp, created_at: earlier_plus_one_sec)

      keeps << create(:track_mentorship, user: jon, track: cpp, created_at: earlier)
      removes << create(:track_mentorship, user: jon, track: ruby, created_at: earlier)

      TrackMentorship.joins(user: :user_tracks).
                      where("user_tracks.track_id = track_mentorships.track_id").
                      where("TIMESTAMPDIFF(SECOND, user_tracks.created_at, track_mentorships.created_at) < 2").
                      delete_all

      assert_equal keeps.size, TrackMentorship.count
      refute TrackMentorship.where(id: removes.map(&:id)).exists?
    end
  end
end
