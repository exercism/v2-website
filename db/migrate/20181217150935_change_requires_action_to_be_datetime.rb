class ChangeRequiresActionToBeDatetime < ActiveRecord::Migration[5.2]
  def change
    add_column :solution_mentorships, :requires_action_since, :datetime, null: true

    SolutionMentorship.includes(:solution).where(requires_action: true).each do |sm|
      d = sm.solution.last_updated_by_user_at
      d = sm.updated_at if sm.updated_at > d
      sm.update(requires_action_since: d)
    end

    #remove_column :solution_mentorships, :requires_action
  end
end
