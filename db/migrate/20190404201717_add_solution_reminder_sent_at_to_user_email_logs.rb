class AddSolutionReminderSentAtToUserEmailLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_email_logs, :remind_about_solution_sent_at, :datetime, null: true
  end
end
