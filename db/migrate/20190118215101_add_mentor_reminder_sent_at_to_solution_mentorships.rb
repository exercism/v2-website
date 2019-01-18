class AddMentorReminderSentAtToSolutionMentorships < ActiveRecord::Migration[5.2]
  def change
    add_column :solution_mentorships, :mentor_reminder_sent_at, :datetime, null: true
  end
end
