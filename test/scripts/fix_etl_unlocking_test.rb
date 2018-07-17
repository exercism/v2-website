require 'test_helper'

# This was run in production:
# Solution.where('created_at > "2018-07-17 14:28"').where('created_at < "2018-07-17 14:37"').where("NOT EXISTS(SELECT NULL FROM iterations WHERE solution_id = solutions.id)").delete_all

module Scripts
  class FixETLUnlockingTest < ActiveSupport::TestCase
    test "unlocks correctly" do
      CreatesSolution.any_instance.stubs(git_sha: SecureRandom.uuid)
      CreatesSolution.any_instance.stubs(repo_url: SecureRandom.uuid)

      Timecop.freeze do
        track1 = create :track
        user1 = create :user
        user2 = create :user
        create :user_track, track: track1, user: user1
        create :user_track, track: track1, user: user2

        core1 = create :exercise, core: true, track: track1
        core2 = create :exercise, core: true, track: track1
        core3 = create :exercise, core: true, track: track1
        core4 = create :exercise, core: true, track: track1
        core1_side1 = create :exercise, core: false, unlocked_by: core1, track: track1, auto_approve: true
        core2_side1 = create :exercise, core: false, unlocked_by: core2, track: track1
        core3_side1 = create :exercise, core: false, unlocked_by: core3, track: track1
        core4_side1 = create :exercise, core: false, unlocked_by: core4, track: track1
        auto_unlock = create :exercise, core: false, unlocked_by: nil, track: track1

        create :solution, exercise: core1, user: user1, completed_at: Time.now - 1.day
        create :solution, exercise: core2, user: user1, completed_at: Time.now - 1.day
        create :solution, exercise: core3, user: user1

        track2 = create :track
        create :user_track, track: track2, user: user1
        t2_core1 = create :exercise, core: true, track: track2, position: 2
        t2_core2 = create :exercise, core: true, track: track2, position: 1
        t2_core1_side1 = create :exercise, core: false, unlocked_by: t2_core1, track: track2
        t2_core2_side1 = create :exercise, core: false, unlocked_by: t2_core2, track: track2
        t2_core2_side2 = create :exercise, core: false, unlocked_by: t2_core2, track: track2
        t2_auto_unlock = create :exercise, core: false, unlocked_by: nil, track: track2

        track3 = create :track
        create :user_track, track: track3, user: user1
        t3_core1 = create :exercise, core: true, track: track3, position: 2
        t3_core2 = create :exercise, core: true, track: track3, position: 1
        t3_auto_unlock = create :exercise, core: false, unlocked_by: nil, track: track3
        create :solution, exercise: t3_core1, user: user1

        track4 = create :track
        create :user_track, track: track4, user: user1
        t4_core1 = create :exercise, core: true, track: track4, position: 1
        t4_core2 = create :exercise, core: true, track: track4, position: 3
        t4_core3 = create :exercise, core: true, track: track4, position: 2
        t4_core4 = create :exercise, core: true, track: track4, position: 4
        create :solution, exercise: t4_core1, user: user1, completed_at: Time.now - 1.day

        FixETLUnlocking.()

        user1.reload

        # Check core on track1 is unchnage
        assert user1.solutions.where(exercise: core1).exists?
        assert user1.solutions.where(exercise: core2).exists?
        assert user1.solutions.where(exercise: core3).exists?
        refute user1.solutions.where(exercise: core4).exists?

        # Check core on track2 is set for the first exercise
        assert user1.solutions.where(exercise: t2_core2).exists?
        refute user1.solutions.where(exercise: t2_core1).exists?

        # Check core on track2 is set for the first exercise
        assert user1.solutions.where(exercise: t3_core1).exists?
        refute user1.solutions.where(exercise: t3_core2).exists?

        assert user1.solutions.where(exercise: auto_unlock).exists?
        assert user1.solutions.where(exercise: core1_side1).exists?
        assert user1.solutions.where(exercise: core2_side1).exists?
        refute user1.solutions.where(exercise: core3_side1).exists?
        refute user1.solutions.where(exercise: core4_side1).exists?

        assert user2.solutions.where(exercise: auto_unlock).exists?
        refute user2.solutions.where(exercise: core1_side1).exists?
        refute user2.solutions.where(exercise: core2_side1).exists?

        refute user1.solutions.where(exercise: t2_core1_side1).exists?
        refute user1.solutions.where(exercise: t2_core2_side1).exists?
        refute user1.solutions.where(exercise: t2_core2_side2).exists?
        assert user1.solutions.where(exercise: t2_auto_unlock).exists?

        assert user1.solutions.where(exercise: t3_auto_unlock).exists?

        assert user1.solutions.where(exercise: t4_core1).exists?
        refute user1.solutions.where(exercise: t4_core2).exists?
        assert user1.solutions.where(exercise: t4_core3).exists?
        refute user1.solutions.where(exercise: t4_core4).exists?
      end
    end
  end
end
