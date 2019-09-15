class AddEmailOnMentorHeartbeatToCommunicationPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, :email_on_mentor_heartbeat, :boolean, null: false, default: true
  end
end
