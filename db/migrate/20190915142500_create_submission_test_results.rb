class CreateSubmissionTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :submission_test_results do |t|
      t.bigint :submission_id, null: false
      t.string :ops_status, null: false
      t.string :results_status
      t.string :message
      t.json :tests
      t.json :results

      t.timestamps

      t.foreign_key :submissions
    end
  end
end
