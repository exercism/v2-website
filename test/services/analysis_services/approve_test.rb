require 'test_helper'

module AnalysisServices
  class AutoApprovesSolutionTest < ActiveSupport::TestCase
    test "approves solution" do
      Timecop.freeze do
        solution = create :solution, last_updated_by_user_at: nil
        create :iteration, solution: solution
        system_user = create :user, :system

        Approve.(solution)

        solution.reload
        assert_equal system_user, solution.approved_by
        assert_nil solution.last_updated_by_user_at
      end
    end

    test "noop unless solution.use_auto_analysis" do
      system_user = create :user, :system
      solution = create :solution
      create :iteration, solution: solution

      solution.stubs(use_auto_analysis?: false)
      Approve.(solution)
      assert_nil solution.reload.approved_by

      solution.stubs(use_auto_analysis?: true)
      Approve.(solution)
      assert_equal system_user, solution.reload.approved_by
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
      create :iteration, solution: solution
      system_user = create(:user, :system)

      stub_repo_cache! do
        Approve.(solution)
      end

      assert unlocked_exercise.unlocked_by_user?(user)
    end

    test "notifies and emails user upon mentor post" do
      solution = create :solution
      create :iteration, solution: solution
      user = solution.user

      # Setup mentor
      system_user = create :user, :system

      CreateNotification.expects(:call).with do |*args|
        assert_equal user, args[0]
        assert_equal :solution_approved, args[1]
        assert_equal "Your solution to <strong>#{solution.exercise.title}</strong> on the <strong>#{solution.exercise.track.title}</strong> track has been automatically approved.", args[2]
        assert_equal "https://test.exercism.io/my/solutions/#{solution.uuid}", args[3]
        assert_equal system_user, args[4][:trigger]
        assert_equal solution, args[4][:about]
      end

      DeliverEmail.expects(:call).with do |*args|
        assert_equal user, args[0]
        assert_equal :solution_approved, args[1]
        assert_equal solution, args[2]
      end

      Approve.(solution)
    end

    test "discussion post created" do
      solution = create :solution, last_updated_by_user_at: nil
      iteration = create :iteration, solution: solution
      system_user = create :user, :system

      Approve.(solution)

      # Check discussion post has been created
      content = {'i18n_message' => 'system_messages.solution_auto_approved'}
      html = ParseMarkdown.("Your solution has been automatically approved by Exercism's automated analyzers. [Read more about how this works](https://exercism.io/help/automated-solution-analysis).")

      dp = DiscussionPost.last
      assert_equal User.system_user, dp.user
      assert_equal iteration, dp.iteration
      assert_equal content, JSON.parse(dp.content)
      assert_equal html, dp.html
    end
  end
end
