require 'test_helper'

class HandleIterationAnalysisTest < ActiveSupport::TestCase
  SUCCESS_STATUS = 'success'.freeze
  APPROVAL_AS_OPTIMAL_DATA = {'status' => "approve_as_optimal"}.freeze

  test "removes any locks" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    system_lock = create :solution_lock, solution: solution, user: create(:user, :system)
    mentor_lock = create :solution_lock, solution: solution
    HandleIterationAnalysis.(iteration, nil, nil)

    assert_raises ActiveRecord::RecordNotFound do
      system_lock.reload
    end

    assert mentor_lock.reload
  end

  test "creates db record" do
    iteration = create :iteration
    status = "success"
    analysis = {"foo" => "bar"}

    HandleIterationAnalysis.(iteration, status, analysis)
    ia = IterationAnalysis.last
    assert_equal iteration, ia.iteration
    assert_equal status, ia.status
    assert_equal analysis, ia.analysis
  end

  test "does not approve if we should have auto analysis" do
    solution = create :solution
    solution.stubs(use_auto_analysis?: false)
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).never
    HandleIterationAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_AS_OPTIMAL_DATA)
  end

  test "does not parse if the analysis return failure" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).never
    HandleIterationAnalysis.(iteration, 'failed', APPROVAL_AS_OPTIMAL_DATA)
  end

  test "auto approves solutions" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).with(solution)
    HandleIterationAnalysis.(iteration, SUCCESS_STATUS, APPROVAL_AS_OPTIMAL_DATA)
  end

  test "does not approve unless optimal (for now)" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).never
    HandleIterationAnalysis.(iteration, SUCCESS_STATUS, {'status' => "approve"})
  end

  test "does not approve if disapprove" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).never
    HandleIterationAnalysis.(iteration, SUCCESS_STATUS, {'status' => "disapprove"})
  end

  test "does not approve if refer_to_mentor" do
    solution = create :solution
    iteration = create :iteration, solution: solution

    AutoApproveSolution.expects(:call).never
    HandleIterationAnalysis.(iteration, SUCCESS_STATUS, {'status' => "refer_to_mentor"})
  end
end

