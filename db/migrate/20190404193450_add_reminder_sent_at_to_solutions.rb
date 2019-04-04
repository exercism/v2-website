class AddReminderSentAtToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :reminder_sent_at, :datetime, null: true
  end
end
