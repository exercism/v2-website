class RenameTestResultsToTestRun < ActiveRecord::Migration[6.0]
  def change
    rename_table :submission_test_results, :submission_test_runs
  end
end
