class AddEmailOnRemindMentorToCommunicationPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, "email_on_remind_mentor", :boolean, default: true, null: false
  end
end
