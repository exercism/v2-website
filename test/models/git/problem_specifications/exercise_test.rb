require 'test_helper'

class Git::ProblemSpecifications::ExerciseTest < ActiveSupport::TestCase
  test "returns title from metadata" do
    Git::ProblemSpecifications.stubs(:repo_url).returns("file://#{Rails.root}/test/fixtures/problem-specifications")
    exercise_tree = Git::ProblemSpecifications.head.exercises.exercise_tree("hello-world")


    exercise = Git::ProblemSpecifications::Exercise.new(Git::ProblemSpecifications.head, exercise_tree)

    assert_equal "Hello World", exercise.title
  end
end
