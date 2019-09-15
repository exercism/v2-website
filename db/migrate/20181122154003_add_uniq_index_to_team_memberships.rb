class AddUniqIndexToTeamMemberships < ActiveRecord::Migration[5.2]
  def change

    # Delete any existing duplicates
    res = TeamMembership.group("team_id, user_id").having("c > 1").pluck("team_id, user_id, COUNT(*) as c")
    res.each do |team_id, user_id, _|
      TeamMembership.where(team_id: team_id, user_id: user_id).offset(1).destroy_all
    end

    add_index :team_memberships, [:team_id, :user_id], unique: true
  end
end
