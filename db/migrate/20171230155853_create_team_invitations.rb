class CreateTeamInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :team_invitations do |t|
      t.bigint :team_id, null: false
      t.bigint :invited_by_id, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :team_invitations, [:team_id, :email], unique: true
    add_foreign_key :team_invitations, :teams
    add_foreign_key :team_invitations, :users, column: :invited_by_id
  end
end
