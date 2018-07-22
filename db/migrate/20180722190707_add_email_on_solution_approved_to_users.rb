class AddEmailOnSolutionApprovedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, :email_on_solution_approved, :boolean, default: true, null: false
  end
end
