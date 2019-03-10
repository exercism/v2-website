require 'test_helper'

class GenerateMentorHeartbeatsTest < ActiveSupport::TestCase

  test "generates for correct mentors" do
    active_mentor_1 = create :user
    active_mentor_2 = create :user
    inactive_mentor = create :user
    antispam_mentor = create :user
    [active_mentor_1, active_mentor_2, inactive_mentor, antispam_mentor].each do |user|
      create :track_mentorship, user: user
    end

    # Create solution mentorships at various boundary conditions
    [active_mentor_1, antispam_mentor].each do |user|
      create :solution_mentorship, created_at: Time.current - 59.days, user: user
    end
    create :solution_mentorship, created_at: Time.current - 59.5.days, user: active_mentor_2
    create :solution_mentorship, created_at: Time.current - 60.5.days, user: inactive_mentor

    # We should sent to users who have received it < 7 days ago.
    create :user_email_log, user: active_mentor_1, mentor_heartbeat_sent_at: Time.current - 6.1.days
    create :user_email_log, user: antispam_mentor, mentor_heartbeat_sent_at: Time.current - 5.9.days

    DeliverEmail.expects(:call).with do |user, mail_type, _, _|
      user == active_mentor_1 && mail_type == :mentor_heartbeat
    end

    DeliverEmail.expects(:call).with do |user, mail_type, _, _|
      user == active_mentor_2 && mail_type == :mentor_heartbeat
    end

    GenerateMentorHeartbeats.()
  end

  test "generates introduction for new users" do
    mentor = create :user
    create :track_mentorship, user: mentor
    create :solution_mentorship, user: mentor

    log = create :user_email_log, user: mentor, mentor_heartbeat_sent_at: nil

    DeliverEmail.expects(:call).with do |user, _, _, introduction|
      user == mentor && introduction.present?
    end
    GenerateMentorHeartbeats.()
  end

  test "generates weekly introduction for existing users" do
    mentor = create :user
    create :track_mentorship, user: mentor
    create :solution_mentorship, user: mentor

    log = create :user_email_log, user: mentor, mentor_heartbeat_sent_at: Time.now - 20.days

    DeliverEmail.expects(:call).with do |user, _, _, introduction|
      user == mentor && introduction == %Q{This week I want to draw attention to the Track Anatomy Project - the work Maud and our maintainers are doing in restructuring tracks to make them more enjoyable to work through and easier to mentor. Our initial testbed has been Ruby, where we've seen a reduction in the average time-to-mentor from days to only a couple of hours. The maintainers of C#, JavaScript, Rust, Python, Haskell, Elixir and Prolog are all working on implementing Maud's work on their tracks too, so if you mentor those tracks, you should start to notice an improvement in your mentoring experience over the coming weeks. Thank you to everyone involved!\n\nHere are this weeks mentoring stats:}
    end
    GenerateMentorHeartbeats.()
  end

  test "generates personal stats correctly" do
    mentor = create :user
    create :track_mentorship, user: mentor
    create :solution_mentorship, user: mentor, created_at: Time.now - 6.9.days
    create :solution_mentorship, user: mentor, created_at: Time.now - 6.9.days
    create :solution_mentorship, user: mentor, created_at: Time.now - 7.1.days

    DeliverEmail.expects(:call).with do |user, _, stats, _|
      assert_equal user, mentor
      assert_equal 2, stats[:num_solutions_mentored_by_user]
    end
    GenerateMentorHeartbeats.()
  end


  test "generates site stats correctly" do
    mentor = create :user
    create :track_mentorship, user: mentor

    # Only these solutions count at all
    solutions = 5.times.map { create(:iteration, created_at: Time.now - 6.9.days).solution }

    # Old solutions with new iterations don't count
    old_solution = create :solution
    create(:iteration, solution: old_solution, created_at: Time.now - 8.days)
    create(:iteration, solution: old_solution, created_at: Time.now - 1.day)

    # Old iterations don't count
    create(:iteration, created_at: Time.now - 7.1.days)

    # Without iteration doesn't count
    create(:solution)

    # First 3 solutions have been submitted for mentoring
    solutions.first(3).each {|s| s.update(mentoring_requested_at: Time.current) }

    # Reduce the number of learners down to 4 by merging two
    solutions.first.update(user_id: solutions.second.user_id)

    # First solution received mentoring (as did the one right at the top
    # of this method when we were setting up the mentor)
    solutions.first(2).each do |solution|
      create :solution_mentorship, solution: solution, user: mentor
      solution.update(last_updated_by_mentor_at: Time.current - 6.days)
    end

    # Old solution mentorships don't count
    create :solution_mentorship, user: mentor, created_at: Time.current - 8.days

    site_stats = {
      num_solutions: 5,
      num_solutions_for_mentoring: 3,
      num_solution_mentorships: 2,
      num_learners: 4,
      num_mentors: 1
    }

    DeliverEmail.expects(:call).at_least_once.with do |_, _, stats|
      assert_equal site_stats, stats[:site]
    end

    GenerateMentorHeartbeats.()
  end

  test "generates track stats correctly" do
    mentor = create :user
    track = create :track
    exercise = create :exercise, track: track
    create :track_mentorship, user: mentor, track: track

    # Only these solutions count at all
    solutions = 5.times.map { create(:iteration, created_at: Time.now - 6.9.days, solution: create(:solution, exercise: exercise)).solution }

    # Different track
    create(:iteration, created_at: Time.now - 6.9.days)

    # Old solutions with new iterations don't count but should be included in the queue
    old_solution = create :solution, exercise: exercise, mentoring_requested_at: Time.now
    create(:iteration, solution: old_solution, created_at: Time.now - 8.days)
    create(:iteration, solution: old_solution, created_at: Time.now - 1.day)

    # Old iterations don't count
    create(:iteration, created_at: Time.now - 7.1.days, solution: create(:solution, exercise: exercise))

    # Without iteration doesn't count
    create(:solution, exercise: exercise)

    # First 3 solutions have been submitted for mentoring
    solutions.first(3).each {|s| s.update(mentoring_requested_at: Time.current) }

    # First two get mentoring. One by this mentor, one by another
    create :solution_mentorship, solution: solutions.first, user: mentor
    create :solution_mentorship, solution: solutions.second

    # Old solution mentorships don't count
    create :solution_mentorship, solution: solutions.second, user: mentor, created_at: Time.current - 8.days

    track_stats = {
      new_solutions_submitted: 5,
      solutions_submitted_for_mentoring: 3,
      total_solutions_mentored: 2,
      solutions_mentored_by_you: 1,
      current_queue_length: 4
    }

    DeliverEmail.expects(:call).with do |_, _, stats|
      assert_equal track.title, stats[:tracks][track.slug][:title]
      assert_equal track_stats, stats[:tracks][track.slug][:stats]
    end

    GenerateMentorHeartbeats.()
  end
end
