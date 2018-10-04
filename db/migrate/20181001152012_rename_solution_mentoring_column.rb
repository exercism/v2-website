class RenameSolutionMentoringColumn < ActiveRecord::Migration[5.2]
  def up
    add_column :solutions, :mentoring_requested_at, :datetime, null: true

    # Set all core exercises that have been started to have mentoring requested at
    # All non-core, not-started, or independent-mode exercises will be reset.
    Solution.where(track_in_independent_mode: false).
             joins(:exercise).merge(Exercise.core).
             submitted.
             update_all("mentoring_requested_at = last_updated_by_user_at")

    # Set all side exercices that already have mentoring to have
    # mentoring_requested set to true.
    Solution.where(track_in_independent_mode: false).
             joins(:exercise).merge(Exercise.side).
             submitted.
             has_a_mentor.
             update_all("mentoring_requested_at = last_updated_by_user_at")

    # This is deliberately commented out in the migration as I want to verify
    # everything has worked in live before deleting this column.
    #remove_column :solutions, :independent_mode
  end

  def down
    remove_column :solutions, :mentoring_requested_at
  end
end
