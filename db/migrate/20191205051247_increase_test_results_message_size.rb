class IncreaseTestResultsMessageSize < ActiveRecord::Migration[6.0]
  def change
    change_column :submission_test_results, :message, :text, null: true
  end
end
