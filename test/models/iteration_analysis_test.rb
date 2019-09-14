require 'test_helper'

class IterationAnalysisTest < ActiveSupport::TestCase
  test "succeeded?" do
    assert create(:iteration_analysis, ops_status: :success).succeeded?
    assert create(:iteration_analysis, ops_status: 'success').succeeded?
    refute create(:iteration_analysis, ops_status: :failed).succeeded?
    refute create(:iteration_analysis, ops_status: :foobar).succeeded?
  end

  test "analysis_status" do
    assert_equal :approve, create(:iteration_analysis, analysis: {status: "approve"}).analysis_status
    assert_equal :approve, create(:iteration_analysis, analysis: {'status' => "approve"}).analysis_status
    assert_equal :approve, create(:iteration_analysis, analysis: {status: :approve}).analysis_status
    assert_equal :approve, create(:iteration_analysis, analysis: {'status' => :approve}).analysis_status
    assert_nil create(:iteration_analysis, analysis: {}).analysis_status
  end

  test "handled?" do
    assert create(:iteration_analysis, analysis: {'status' => :approve}).handled?
    assert create(:iteration_analysis, analysis: {'status' => :approve_as_optimal}).handled?
    assert create(:iteration_analysis, analysis: {'status' => :disapprove}).handled?
    refute create(:iteration_analysis, analysis: {'status' => :refer_to_mentor}).handled?
  end

  test "analysis" do
    assert_equal({foo: 'bar'}, create(:iteration_analysis, analysis: {foo: :bar}).analysis)
    assert_equal({foo: 'bar'}, create(:iteration_analysis, analysis: {'foo' => :bar}).analysis)
    assert_equal({}, create(:iteration_analysis, analysis: {}).analysis)
    assert_equal({}, create(:iteration_analysis, analysis: nil).analysis)
  end
end
