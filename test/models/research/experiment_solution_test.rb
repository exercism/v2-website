require 'test_helper'

module Research
  class ExperimentSolutionTest < ActiveSupport::TestCase
    test "the truth" do
      ruby_a_1 = create :exercise, slug: "ruby-a-1"
      ruby_a_2 = create :exercise, slug: "ruby-a-2"
      ruby_b_1 = create :exercise, slug: "ruby-b-1"
      ruby_b_2 = create :exercise, slug: "ruby-b-2"
      common_lisp_1_a = create :exercise, slug: "common-lisp-a-1"
      csharp_a_1 = create :exercise, slug: "csharp-a-1"

      s_ruby_a_1 = create :research_experiment_solution, exercise: ruby_a_1
      s_ruby_a_2 = create :research_experiment_solution, exercise: ruby_a_2
      s_ruby_b_1 = create :research_experiment_solution, exercise: ruby_b_1
      s_ruby_b_2 = create :research_experiment_solution, exercise: ruby_b_2
      s_common_lisp_1_a = create :research_experiment_solution, exercise: common_lisp_1_a
      s_csharp_a_1 = create :research_experiment_solution, exercise: csharp_a_1

      assert_equal [s_ruby_a_1, s_ruby_a_2].map(&:id), Research::ExperimentSolution.by_language_part(language_slug: :ruby, part: 'a').map(&:id)
      assert_equal [s_csharp_a_1], Research::ExperimentSolution.by_language_part(language_slug: :csharp, part: 'a')
      assert_equal [], Research::ExperimentSolution.by_language_part(language_slug: :csharp, part: 'b')
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
  end
end
