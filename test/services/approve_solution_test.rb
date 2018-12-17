require 'test_helper'

class ApprovesSolutionTest < ActiveSupport::TestCase
  test "approves solution" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil

      mentor = create :user
      create :track_mentorship, user: mentor, track: solution.exercise.track
      create :solution_mentorship, solution: solution, user: mentor

      ApproveSolution.(solution, mentor)

      solution.reload
      assert_equal mentor, solution.approved_by
      assert_nil solution.last_updated_by_user_at
      assert_equal DateTime.now.to_i, solution.last_updated_by_mentor_at.to_i
    end
  end

  test "unlocks side exercises for a completed solution" do
    user = create(:user)
    track = create(:track, repo_url: "file://#{Rails.root}/test/fixtures/track")
    exercise = create(:exercise, track: track)
    unlocked_exercise = create(:exercise, unlocked_by: exercise, track: track)
    create(:user_track, track: track, user: user)
    solution = create(:solution,
                      user: user,
                      exercise: exercise,
                      completed_at: Time.utc(2018, 6, 25))
    mentor = create(:user)
    create(:track_mentorship, user: mentor, track: track)
    create(:solution_mentorship, solution: solution, user: mentor)

    stub_repo_cache! do
      ApproveSolution.(solution, mentor)
    end

    assert unlocked_exercise.unlocked_by_user?(user)
  end

  test "fails for non-mentor" do
    refute ApproveSolution.(create(:solution), create(:user))
  end

  test "fails for mentor of different track" do
    mentor = create :user
    create :track_mentorship, user: mentor
    different_track_solution = create(:solution)
    refute ApproveSolution.(different_track_solution, mentor)
  end

  test "notifies and emails user upon mentor post" do
    solution = create :solution
    user = solution.user

    # Setup mentor
    mentor = create :user
    create :track_mentorship, user: mentor, track: solution.exercise.track
    create :solution_mentorship, solution: solution, user: mentor

    CreateNotification.expects(:call).with do |*args|
      assert_equal user, args[0]
      assert_equal :solution_approved, args[1]
      assert_equal "<strong>#{mentor.handle}</strong> has approved your solution to <strong>#{solution.exercise.title}</strong> on the <strong>#{solution.exercise.track.title}</strong> track.", args[2]
      assert_equal "https://test.exercism.io/my/solutions/#{solution.uuid}", args[3]
      assert_equal mentor, args[4][:trigger]
      assert_equal solution, args[4][:about]
    end

    DeliverEmail.expects(:call).with do |*args|
      assert_equal user, args[0]
      assert_equal :solution_approved, args[1]
      assert_equal solution, args[2]
    end

    ApproveSolution.(solution, mentor)
  end

  test "creates solution_mentorship" do
    solution = create :solution
    mentor = create :user
    create :track_mentorship, user: mentor, track: solution.exercise.track

    CreateSolutionMentorship.expects(:call).with(solution, mentor)
    ApproveSolution.(solution, mentor)
  end

  test "cancels all mentors' requires_action" do
    solution = create :solution
    mentor1 = create :user
    mentor2 = create :user
    create :track_mentorship, user: mentor1, track: solution.exercise.track
    create :track_mentorship, user: mentor2, track: solution.exercise.track
    mentorship1 = create :solution_mentorship, user: mentor1, solution: solution, requires_action_since: Time.current
    mentorship2 = create :solution_mentorship, user: mentor2, solution: solution, requires_action_since: Time.current

    ApproveSolution.(solution, mentor1)

    [mentorship1, mentorship2].each(&:reload)
    refute mentorship1.requires_action?
    refute mentorship2.requires_action?
  end
end
