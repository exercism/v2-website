require 'test_helper'

class GitExerciseTest < ActiveSupport::TestCase
  test "test instructions leaves title if it doesn't match" do
    exercise = create :exercise, title: 'foobar'

    readme_lines = ["# barfoo", "### Something else", "Here"]

    readme = mock(lines: readme_lines)
    exercise_reader = mock(readme: readme)

    git_exercise = Git::Exercise.new(exercise, nil, nil)
    git_exercise.expects(:exercise_reader).returns(exercise_reader)

    expected = ParseMarkdown.(readme_lines.join("\n"))
    assert_equal expected, git_exercise.instructions
  end

  test "test instructions removes title if it matches" do
    exercise = create :exercise, title: 'foobar'

    original_readme_lines = ["# foobar", "### Something else", "Here"]
    modified_readme_lines = ["### Something else", "Here"]

    readme = mock(lines: original_readme_lines)
    exercise_reader = mock(readme: readme)

    git_exercise = Git::Exercise.new(exercise, nil, nil)
    git_exercise.expects(:exercise_reader).returns(exercise_reader)

    expected = ParseMarkdown.(modified_readme_lines.join("\n"))
    assert_equal expected, git_exercise.instructions
  end

  test "test returns test_suite" do
    skip
  end
end
