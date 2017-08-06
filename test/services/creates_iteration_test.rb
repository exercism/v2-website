require 'test_helper'

class CreatesIterationTest < ActiveSupport::TestCase
  test "creates for iteration user" do
    solution = create :solution
    code = "foobar"
    filename = "foobar.rb"
    content_type = "text/plain"
    file_contents = "something = :else"

    file = mock(original_filename: filename, content_type: content_type, read: file_contents)

    iteration = CreatesIteration.create!(solution, [file])

    assert iteration.persisted?
    assert_equal iteration.solution, solution
    assert_equal 1, iteration.files.count

    saved_file = iteration.files.first
    assert_equal filename, saved_file.filename
    assert_equal content_type, saved_file.content_type
    assert_equal file_contents, saved_file.file_contents
  end

  test "updates last updated by" do
    Timecop.freeze do
      solution = create :solution, last_updated_by_user_at: nil
      assert_nil solution.last_updated_by_user_at

      CreatesIteration.create!(solution, [])
      assert_equal DateTime.now.to_i, solution.last_updated_by_user_at.to_i
    end
  end

  test "set all mentors' requires_action to true" do
    solution = create :solution
    mentor = create :user
    mentorship = create :solution_mentorship, user: mentor, solution: solution, requires_action: false

    CreatesIteration.create!(solution, [])

    mentorship.reload
    assert mentorship.requires_action
  end

  test "notifies and emails mentors" do
    solution = create :solution
    user = solution.user

    # Setup mentors
    mentor1 = create :user
    mentor2 = create :user
    create :solution_mentorship, solution: solution, user: mentor1
    create :solution_mentorship, solution: solution, user: mentor2

    CreatesNotification.expects(:create!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal "#{user.name} has posted a new iteration on a solution you are mentoring", args[2]
      assert_equal "https://exercism.io/mentor/solutions/#{solution.uuid}", args[3]
      assert_equal solution, args[4][:about]
    end

    DeliversEmail.expects(:deliver!).twice.with do |*args|
      assert [mentor1, mentor2].include?(args[0])
      assert_equal :new_iteration_for_mentor, args[1]
      assert_equal Iteration, args[2].class
    end

    CreatesIteration.create!(solution, [])
  end


end

