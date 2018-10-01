class RenameSolutionMentoringColumn < ActiveRecord::Migration[5.2]
  def up
    add_column :solutions, :mentoring_requested_at, :datetime, null: true
    Solution.where(independent_mode: false).
             update_all("mentoring_requested_at = last_updated_by_user_at")
  end

  def down
    remove_column :solutions, :mentoring_requested_at
  end
end
