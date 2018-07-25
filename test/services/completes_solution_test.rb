require 'test_helper'

class CompletesSolutionTest < ActiveSupport::TestCase
  setup do
    @track = create :track
    @core_exercise = create :exercise, track: @track, core: true, position: 1
    @other_core_exercise = create :exercise, track: @track, core: true, position: 3
    @next_core_exercise = create :exercise, track: @track, core: true, position: 2
    @another_core_exercise = create :exercise, track: @track, core: true, position: 4

    @side_exercise = create :exercise, track: @track, core: false, unlocked_by: @core_exercise
    @other_side_exercise = create :exercise, track: @track, core: false, unlocked_by: create(:exercise)

    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
  end

  test "completes solution, unlocks next core and side quests when mentor approved" do
    Timecop.freeze do
      user = create :user
      mentor = create :user
      solution = create :solution, user: user, exercise: @core_exercise, approved_by: mentor
      create :user_track, user: user, track: @track

      UnlocksNextCoreExercise.expects(:call).with(@track, user)

      CompletesSolution.complete!(solution)

      assert_equal DateTime.now.to_i, solution.completed_at.to_i

      assert Solution.where(user: user, exercise: @side_exercise).exists?
      refute Solution.where(user: user, exercise: @other_side_exercise).exists?
    end
  end

  test "completes solution and does not unlock next core when not mentor approved" do
    skip
    Timecop.freeze do
      user = create :user
      solution = create :solution, user: user, exercise: @core_exercise

      CompletesSolution.complete!(solution)

      assert_equal DateTime.now.to_i, solution.completed_at.to_i

      assert Solution.where(user: user, exercise: @next_core_exercise).exists?

      refute Solution.where(user: user, exercise: @side_exercise).exists?
      refute Solution.where(user: user, exercise: @other_side_exercise).exists?
      refute Solution.where(user: user, exercise: @other_core_exercise).exists?
      refute Solution.where(user: user, exercise: @another_core_exercise).exists?
    end
  end

  test "does not double-unlock side-quest" do
    Timecop.freeze do
      user = create :user
      mentor = create :user
      create :solution, user: user, exercise: @side_exercise
      solution = create :solution, user: user, exercise: @core_exercise, approved_by: mentor
      create :user_track, user: user, track: @track

      CompletesSolution.complete!(solution)
      assert_equal 1, Solution.where(user: user, exercise: @next_core_exercise).count
    end
  end

  test "test completing last exercise completes the track" do
    skip # TODO
  end
end
