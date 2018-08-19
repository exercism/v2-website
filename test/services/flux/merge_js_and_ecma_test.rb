require 'test_helper'

module Flux
  class MergeJSandECMATest < ActiveSupport::TestCase
    setup do
      @js = create :track, slug: "javascript", title: "JavaScript"
      @ecma = create :track, slug: "ecmascript", title: "ECMAScript"
      @ruby = create :track, slug: "ruby", title: "Ruby"

      @js_hamming = create :exercise, slug: 'hamming', title: "Hamming", track: @js
      @ecma_hamming = create :exercise, slug: 'hamming', title: "Hamming", track: @ecma
      @ruby_hamming = create :exercise, slug: 'hamming', title: "Hamming", track: @ruby
      @js_bob = create :exercise, slug: 'bob', track: @js
      @ecma_bob = create :exercise, slug: 'bob', track: @ecma
      @ruby_bob = create :exercise, slug: 'bob', track: @ruby

      # Create a migration bot user for foreign key constraints
      create :user, id: 1
    end

    test "JS Sha is correct" do
      assert_equal "6a8a5a41b89a45008b46ca18ff7ea800baca1c4c", MergeJSAndECMA::JS_SHA
    end

    test "tracks are renamed" do
      MergeJSAndECMA.()
      [@js, @ecma].each(&:reload)

      assert_equal "JavaScript (Legacy)", @js.title
      assert_equal "javascript-legacy", @js.slug
      refute @js.active?

      assert_equal "JavaScript", @ecma.title
      assert_equal "javascript", @ecma.slug
      assert @ecma.active?
    end

    test "FixUnlockingInUserTrack is called for affected users" do
      ecma_user = create :user
      js_user = create :user
      both_user = create :user
      ruby_user = create :user

      ut1 = create :user_track, user: js_user, track: @js
      ut2 = create :user_track, user: ecma_user, track: @ecma
      ut3 = create :user_track, user: both_user, track: @ecma
      ut4 = create :user_track, user: both_user, track: @js
      ut5 = create :user_track, user: ruby_user, track: @ruby

      FixUnlockingInUserTrack.expects(:call).with(ut1)
      FixUnlockingInUserTrack.expects(:call).with(ut2) # Run it on all ecma to be safe
      FixUnlockingInUserTrack.expects(:call).with(ut3)

      # This shouldn't be called for the ecma or ruby tracks, or for the legacy js on both
      FixUnlockingInUserTrack.expects(:call).with(ut4).never
      FixUnlockingInUserTrack.expects(:call).with(ut5).never

      MergeJSAndECMA.()
    end

    test "locks the JS solution shas" do
      ecma_sha = SecureRandom.uuid

      js_bob_solution = create :solution, exercise: @js_bob, git_sha: SecureRandom.uuid, downloaded_at: Time.now
      ecma_bob_solution = create :solution, exercise: @ecma_bob, git_sha: ecma_sha, downloaded_at: Time.now

      MergeJSAndECMA.()

      [js_bob_solution, ecma_bob_solution].each(&:reload)

      assert_equal MergeJSAndECMA::JS_SHA, js_bob_solution.git_sha
      assert_equal ecma_sha, ecma_bob_solution.git_sha
    end

    test "create ecma user track and removes js user tracks" do
      ecma_user = create :user
      mentored_js_user = create :user
      independent_js_user = create :user
      both_user = create :user
      ruby_user = create :user

      ecma_user_track = create :user_track, user: ecma_user, track: @ecma
      mentored_js_track = create :user_track, user: mentored_js_user, track: @js, independent_mode: false
      independent_js_track = create :user_track, user: independent_js_user, track: @js, independent_mode: true
      both_js_track = create :user_track, user: both_user, track: @js
      both_ecma_track = create :user_track, user: both_user, track: @ecma
      ruby_user_track = create :user_track, user: ruby_user, track: @ruby

      MergeJSAndECMA.()

      # Check we've just repointed the existing tracks
      [mentored_js_track, independent_js_track].each(&:reload)
      assert_equal @ecma, mentored_js_track.track
      assert_equal @ecma, independent_js_track.track

      # Check there is an ecma track for everyone and a js track for no-one
      assert_equal [mentored_js_user, independent_js_user, ecma_user, both_user].map(&:id).sort, UserTrack.where(track: @ecma).pluck(:user_id).sort
      assert_equal [].map(&:id), UserTrack.where(track: @js).pluck(:user_id)

      # Check the actual ecma user track is still the same object
      assert_equal ecma_user_track, UserTrack.find_by(track: @ecma, user: ecma_user)

      # Check the ruby track is unaffected
      assert_equal ruby_user_track, UserTrack.find_by(track: @ruby, user: ruby_user)

      # Check indepedent_mode is honoured
      refute UserTrack.find_by(track: @ecma, user: mentored_js_user).independent_mode
      assert UserTrack.find_by(track: @ecma, user: independent_js_user).independent_mode
    end

    test "create ecma track_mentorship" do
      ecma_mentor = create :user
      js_mentor = create :user
      both_mentor = create :user
      ruby_mentor = create :user

      ecma_track_mentorship = create :track_mentorship, user: ecma_mentor, track: @ecma
      create :track_mentorship, user: js_mentor, track: @js
      create :track_mentorship, user: both_mentor, track: @js
      create :track_mentorship, user: both_mentor, track: @ecma
      ruby_track_mentorship = create :track_mentorship, user: ruby_mentor, track: @ruby

      MergeJSAndECMA.()

      # Check there is an ecma track mentorship for everyone and a js track mentorship for no-one
      assert_equal [js_mentor, ecma_mentor, both_mentor].map(&:id).sort, TrackMentorship.where(track_id: @ecma.id).pluck(:user_id).sort
      assert_equal [].map(&:id), TrackMentorship.where(track: @js).pluck(:user_id)

      # Check the actual ecma track mentorship is still the same object
      assert_equal ecma_track_mentorship, TrackMentorship.find_by(track: @ecma, user: ecma_mentor)

      # Check the ruby track mentorship is unaffected
      assert_equal ruby_track_mentorship, TrackMentorship.find_by(track: @ruby, user: ruby_mentor)
    end

    test "renames and moves the exercises correctly" do
      MergeJSAndECMA.()

      [@js_hamming, @ecma_hamming, @ruby_hamming].each(&:reload)

      assert_equal 'legacy-hamming', @js_hamming.slug
      assert_equal 'Hamming (Legacy)', @js_hamming.title
      assert_equal @ecma, @js_hamming.track

      assert_equal 'hamming', @ecma_hamming.slug
      assert_equal 'Hamming', @ecma_hamming.title
      assert_equal @ecma, @ecma_hamming.track

      assert_equal 'hamming', @ruby_hamming.slug
      assert_equal 'Hamming', @ruby_hamming.title
      assert_equal @ruby, @ruby_hamming.track
    end

    test "ruby and ecma exercises don't get touched" do
      ecma_bob_solution = create_solution(@ecma_bob, :started)
      ruby_bob_solution = create_solution(@ruby_bob, :started)
      ecma_hamming_solution = create_solution(@ecma_hamming, :started)
      ruby_hamming_solution = create_solution(@ruby_hamming, :started)

      MergeJSAndECMA.()

      [
        ecma_bob_solution, ruby_bob_solution, ecma_hamming_solution, ruby_hamming_solution
      ].each(&:reload)

      # Check ecma is unchanged
      assert_equal @ecma_bob, ecma_bob_solution.exercise
      assert_equal @ecma_hamming, ecma_hamming_solution.exercise

      # Check Ruby is unchanged
      assert_equal @ruby_bob, ruby_bob_solution.exercise
      assert_equal @ruby_hamming, ruby_hamming_solution.exercise
    end

    test "exercises are migrated if there is no clash" do
      js_bob_solution = create_solution(@js_bob, :started)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_active js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and ecma is approved" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :started, user)
      ecma_bob_solution = create_solution(@ecma_bob, :approved, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and ecma is completed" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :started, user)
      ecma_bob_solution = create_solution(@ecma_bob, :completed, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and js is completed but ecma is started" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :completed, user)
      ecma_bob_solution = create_solution(@ecma_bob, :started, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and js is approved but ecma is started" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :approved, user)
      ecma_bob_solution = create_solution(@ecma_bob, :started, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and js is approved and ecma is completed" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :approved, user)
      ecma_bob_solution = create_solution(@ecma_bob, :completed, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and js is completed and ecma is approved" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :completed, user)
      ecma_bob_solution = create_solution(@ecma_bob, :approved, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and both are approved" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :approved, user)
      ecma_bob_solution = create_solution(@ecma_bob, :approved, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and both are completed" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :completed, user)
      ecma_bob_solution = create_solution(@ecma_bob, :completed, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "exercises are migrated to legacy exercise if there is a clash and both are started" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :started, user)
      ecma_bob_solution = create_solution(@ecma_bob, :started, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      assert_migrated_to_legacy js_bob_solution
    end

    test "solutions are destroyed if unlocked" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :unlocked, user)
      ecma_bob_solution = create_solution(@ecma_bob, :unlocked, user)

      MergeJSAndECMA.()
      refute Solution.where(id: js_bob_solution.id).exists?
      refute Solution.where(id: ecma_bob_solution.id).exists?
    end

    test "solutions are destroyed if js is unlocked" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :unlocked, user)
      ecma_bob_solution = create_solution(@ecma_bob, :started, user)

      MergeJSAndECMA.()
      refute Solution.where(id: js_bob_solution.id).exists?
    end

    test "exercises are migrated to ecma exercise if there is a clash and ecma is not started but js is started" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :started, user)
      ecma_bob_solution = create_solution(@ecma_bob, :unlocked, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      # The ecma solution should be deleted in this case
      refute Solution.where(id: ecma_bob_solution.id).exists?

      assert_migrated_to_active js_bob_solution
    end

    test "exercises are migrated to ecma exercise if there is a clash and ecma is not started but js is approved" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :approved, user)
      ecma_bob_solution = create_solution(@ecma_bob, :unlocked, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      # The ecma solution should be deleted in this case
      refute Solution.where(id: ecma_bob_solution.id).exists?

      assert_migrated_to_active js_bob_solution
    end

    test "exercises are migrated to ecma exercise if there is a clash and ecma is not started but js is completed" do
      user = create :user
      js_bob_solution = create_solution(@js_bob, :completed, user)
      ecma_bob_solution = create_solution(@ecma_bob, :unlocked, user)

      MergeJSAndECMA.()
      js_bob_solution.reload

      # The ecma solution should be deleted in this case
      refute Solution.where(id: ecma_bob_solution.id).exists?

      assert_equal @ecma_bob, js_bob_solution.exercise
      assert js_bob_solution.completed?
    end

    def assert_migrated_to_legacy(solution)
      assert_equal @js_bob, solution.exercise
      assert_equal 1, solution.approved_by_id
      assert_equal Exercism::JS_AND_ECMA_MERGED_AT, solution.completed_at
    end

    def assert_migrated_to_active(solution)
      assert_equal @ecma_bob, solution.exercise
      refute solution.completed_at
    end

    def create_solution(exercise, state, user = create(:user))
      case state
      when :unlocked
        create :solution, exercise: exercise, user: user
      when :started
        create :solution, exercise: exercise, downloaded_at: Time.now, user: user
      when :approved
        create :solution, exercise: exercise, downloaded_at: Time.now, approved_by: create(:user), user: user
      when :completed
        create :solution, exercise: exercise, downloaded_at: Time.now, completed_at: Time.now, user: user
      end
    end
  end
end
