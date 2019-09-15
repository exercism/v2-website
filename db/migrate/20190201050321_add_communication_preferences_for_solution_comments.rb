class AddCommunicationPreferencesForSolutionComments < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, :email_on_new_solution_comment_for_solution_user, :boolean, null: false, default: true
    add_column :communication_preferences, :email_on_new_solution_comment_for_other_commenter, :boolean, null: false, default: true
  end
end
