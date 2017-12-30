class CreateTeamMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :team_memberships do |t|
      t.bigint :team_id, null: false
      t.bigint :user_id, null: false

      t.boolean :admin, null: false, default: false
      t.boolean :pending, null: false, default: true

      t.timestamps
    end

    add_foreign_key :team_memberships, :teams
    add_foreign_key :team_memberships, :users
  end
end
