require 'test_helper'

module Research
  class ExperimentSolutionTest < ActiveSupport::TestCase
    test "the truth" do
      ruby_1_a = create :exercise, slug: "ruby-1-a"
      ruby_1_b = create :exercise, slug: "ruby-1-b"
      ruby_2_a = create :exercise, slug: "ruby-2-a"
      ruby_2_b = create :exercise, slug: "ruby-2-b"
      common_lisp_1_a = create :exercise, slug: "common-lisp-1-a"
      csharp_1_a = create :exercise, slug: "csharp-1-a"

      s_ruby_1_a = create :research_experiment_solution, exercise: ruby_1_a
      s_ruby_1_b = create :research_experiment_solution, exercise: ruby_1_b
      s_ruby_2_a = create :research_experiment_solution, exercise: ruby_2_a
      s_ruby_2_b = create :research_experiment_solution, exercise: ruby_2_b
      s_common_lisp_1_a = create :research_experiment_solution, exercise: common_lisp_1_a
      s_csharp_1_a = create :research_experiment_solution, exercise: csharp_1_a

      assert_equal [s_ruby_1_a, s_ruby_1_b].map(&:id), Research::ExperimentSolution.by_language_part(language_slug: :ruby, part: 1).map(&:id)
      assert_equal [s_csharp_1_a], Research::ExperimentSolution.by_language_part(language_slug: :csharp, part: 1)
      assert_equal [], Research::ExperimentSolution.by_language_part(language_slug: :csharp, part: 2)
    end

    test "solution pivots" do
      solution = create :research_experiment_solution
      assert solution.research_experiment_solution?
      refute solution.team_solution?
      refute solution.use_auto_analysis?
    end

    test "language_slug" do
      ruby_solution = create(:research_experiment_solution, exercise: create(:exercise, slug: "ruby-b-2"))
      lisp_solution = create(:research_experiment_solution, exercise: create(:exercise, slug: "common-lisp-a-1"))
      assert_equal :ruby, ruby_solution.language_slug
      assert_equal :"common-lisp", lisp_solution.language_slug
    end

    test "latest_files returns latest submission file" do
      solution = create(:research_experiment_solution)
      submission = create(:submission, solution: solution)
      submission.stubs(files: { "subdir/ruby_1_a.rb" => "NEW" })
      solution.submissions = [submission]

      assert_equal({ "subdir/ruby_1_a.rb" => "NEW" }, solution.latest_files)
    end

    test "latest_files returns boilerplate file when no submissions are done" do
      solution = create(:research_experiment_solution)

      assert_equal({ "subdir/ruby_1_a.rb" => "TODO\n" }, solution.latest_files)
    end

    test "#submit! records submission time" do
      solution = build(:research_experiment_solution)
      submission = build(:submission)
      submission.stubs(:pass?).returns(true)
      solution.submissions = [submission]

      solution.submit!(time: Date.new(2016, 12, 25))

      solution.reload
      assert_equal Date.new(2016, 12, 25), solution.finished_at
    end

    test "#submit! raises an error when last submission hasn't passed" do
      solution = build(:research_experiment_solution)
      submission = build(:submission)
      submission.stubs(:pass?).returns(false)
      solution.submissions = [submission]

      assert_raises ExperimentSolution::NotAllowedToSubmitError do
        solution.submit!
      end
    end
  end
end
