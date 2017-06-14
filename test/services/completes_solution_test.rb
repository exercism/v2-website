require 'test_helper'

class StartsSolutionTest < ActiveSupport::TestCase
  setup do
    track = create :track
    @core_exercise = create :exercise, track: track, core: true, position: 1
    @other_core_exercise = create :exercise, track: track, core: true, position: 3
    @next_core_exercise = create :exercise, track: track, core: true, position: 2
    @another_core_exercise = create :exercise, track: track, core: true, position: 4

    @side_exercise = create :exercise, core: false, unlocked_by: @core_exercise
    @other_side_exercise = create :exercise, core: false, unlocked_by: create(:exercise)
  end

  test "completes solution, unlocks next core and side quests when mentor approved" do
    Timecop.freeze do
      user = create :user
      mentor = create :user
      solution = create :solution, user: user, exercise: @core_exercise, approved_by_mentor: mentor

      CompletesSolution.complete!(solution)

      assert_equal DateTime.now.to_i, solution.completed_at.to_i
      assert_equal "completed_approved", solution.status

      assert Solution.where(user: user, exercise: @next_core_exercise, status: "unlocked").exists?
      assert Solution.where(user: user, exercise: @side_exercise, status: "unlocked").exists?

      refute Solution.where(user: user, exercise: @other_side_exercise, status: "unlocked").exists?
      refute Solution.where(user: user, exercise: @other_core_exercise, status: "unlocked").exists?
      refute Solution.where(user: user, exercise: @another_core_exercise, status: "unlocked").exists?
    end
  end

  test "completes solution and unlocks next core" do
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, exercise: @core_exercise

      CompletesSolution.complete!(solution)

      assert_equal DateTime.now.to_i, solution.completed_at.to_i
      assert_equal "completed_unapproved", solution.status

      assert Solution.where(user: user, exercise: @next_core_exercise, status: "unlocked").exists?

      refute Solution.where(user: user, exercise: @side_exercise, status: "unlocked").exists?
      refute Solution.where(user: user, exercise: @other_side_exercise, status: "unlocked").exists?
      refute Solution.where(user: user, exercise: @other_core_exercise, status: "unlocked").exists?
      refute Solution.where(user: user, exercise: @another_core_exercise, status: "unlocked").exists?
    end
  end

  test "test completing last exercise completes the track" do
    skip # TODO
  end
end


