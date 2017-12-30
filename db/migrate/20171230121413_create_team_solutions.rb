class CreateTeamSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :team_solutions do |t|
      t.bigint :user_id, null: false
      t.string :uuid, null: false
      t.bigint :exercise_id, null: false

      t.string :git_sha, null: false
      t.string :git_slug, null: false

      t.timestamps
    end
  end
end
