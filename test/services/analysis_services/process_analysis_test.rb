require 'test_helper'

module AnalysisServices
  class ProcessAnalysisTest < ActiveSupport::TestCase
    SUCCESS_STATUS = 'success'.freeze
    APPROVAL_AS_OPTIMAL_DATA = {'status' => "approve_as_optimal"}.freeze
    APPROVAL_WITH_COMMENT_DATA = {'status' => "approve_with_comment"}.freeze
    APPROVAL_DATA = { 'status' => "approve" }.freeze

    test "removes any locks" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      system_lock = create :solution_lock, solution: solution, user: create(:user, :system)
      mentor_lock = create :solution_lock, solution: solution
      ProcessAnalysis.(iteration, nil, nil)

      assert_raises ActiveRecord::RecordNotFound do
        system_lock.reload
      end

      assert mentor_lock.reload
    end

    test "creates db record" do
      iteration = create :iteration
      status = "success"
      analysis = {"foo" => "bar"}

      ProcessAnalysis.(iteration, status, analysis)
      ia = IterationAnalysis.last
      assert_equal iteration, ia.iteration
      assert_equal status, ia.status
      assert_equal analysis, ia.analysis
    end

    test "does not approve if we should have auto analysis" do
      solution = create :solution
      solution.stubs(use_auto_analysis?: false)
      iteration = create :iteration, solution: solution

      Approve.expects(:call).never
      ProcessAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_AS_OPTIMAL_DATA)
    end

    test "does not parse if the analysis return failure" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).never
      ProcessAnalysis.(iteration, 'failed', APPROVAL_AS_OPTIMAL_DATA)
    end

    test "approves solutions for approve" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).with(solution)
      ProcessAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_DATA)
    end

    test "approves solutions for legacy approve_as_optimal" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).with(solution)
      ProcessAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_AS_OPTIMAL_DATA)
    end

    test "approves solutions for legacy approve_with_comment" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).with(solution)
      ProcessAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_WITH_COMMENT_DATA)
    end

    test "does not approve if disapprove" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).never
      ProcessAnalysis.(iteration, SUCCESS_STATUS, {'status' => "disapprove"})
    end

    test "does not approve if refer_to_mentor" do
      solution = create :solution
      iteration = create :iteration, solution: solution

      Approve.expects(:call).never
      ProcessAnalysis.(iteration, SUCCESS_STATUS, {'status' => "refer_to_mentor"})
    end

    test "posts comments" do
      comments = ["ruby.two-fer.string_building", "ruby.two-fer.avoid_kernel_format"]

      data = {
        'status' => "approve",
        'comments' => comments
      }.freeze

      solution = create :solution
      iteration = create :iteration, solution: solution

      PostComments.expects(:call).with(iteration, comments)
      Approve.expects(:call).with(solution)
      ProcessAnalysis.(iteration, SUCCESS_STATUS, data)
    end
  end
end
