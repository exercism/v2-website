class AddEmailOnRemindAboutSolutionToCommunicationPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, :email_on_remind_about_solution, :boolean, null: false, default: true
  end
end
