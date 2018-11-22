class AddTokenToTeamInvitations < ActiveRecord::Migration[5.2]
  def change
    add_column :team_invitations, :token, :string, null: true
    TeamInvitation.find_each {|ti| ti.update(token: SecureRandom.uuid) }
    change_column_null :team_invitations, :token, false
  end
end
