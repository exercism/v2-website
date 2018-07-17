require 'test_helper'

module Scripts
  class FixETLUnlockingTest < ActiveSupport::TestCase
    test "unlocks correctly" do
      CreatesSolution.any_instance.stubs(git_sha: SecureRandom.uuid)
      CreatesSolution.any_instance.stubs(repo_url: SecureRandom.uuid)

      Timecop.freeze do
        track = create :track
        user1 = create :user
        user2 = create :user
        create :user_track, track: track, user: user1
        create :user_track, track: track, user: user2

        core1 = create :exercise, core: true, track: track
        core2 = create :exercise, core: true, track: track
        core3 = create :exercise, core: true, track: track
        core4 = create :exercise, core: true, track: track
        core1_side1 = create :exercise, core: false, unlocked_by: core1, track: track, auto_approve: true
        core2_side1 = create :exercise, core: false, unlocked_by: core2, track: track
        core3_side1 = create :exercise, core: false, unlocked_by: core3, track: track
        core4_side1 = create :exercise, core: false, unlocked_by: core4, track: track
        auto_unlock = create :exercise, core: false, unlocked_by: nil, track: track

        create :solution, exercise: core1, user: user1, completed_at: Time.now - 1.day
        create :solution, exercise: core2, user: user1, completed_at: Time.now - 1.day
        create :solution, exercise: core3, user: user1
        FixETLUnlocking.()

        user1.reload

        # Check core is unchnage
        assert user1.solutions.where(exercise: core1).exists?
        assert user1.solutions.where(exercise: core2).exists?
        assert user1.solutions.where(exercise: core3).exists?
        refute user1.solutions.where(exercise: core4).exists?

        assert user1.solutions.where(exercise: auto_unlock).exists?
        assert user1.solutions.where(exercise: core1_side1).exists?
        assert user1.solutions.where(exercise: core2_side1).exists?
        refute user1.solutions.where(exercise: core3_side1).exists?
        refute user1.solutions.where(exercise: core4_side1).exists?

        assert user2.solutions.where(exercise: auto_unlock).exists?
        refute user2.solutions.where(exercise: core1_side1).exists?
        refute user2.solutions.where(exercise: core2_side1).exists?
      end
    end
  end
end
