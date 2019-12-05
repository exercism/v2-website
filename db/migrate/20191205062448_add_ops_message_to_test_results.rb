class AddOpsMessageToTestResults < ActiveRecord::Migration[6.0]
  def change
    remove_column :submission_test_results, :ops_status
    add_column :submission_test_results, :ops_status, :smallint, null: true
    add_column :submission_test_results, :ops_message, :text, null: true

    SubmissionTestResults.update_all(ops_status: 0)

    change_column_null :submission_test_results, :ops_status, false
  end
end
