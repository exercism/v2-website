class CreateTeamSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :team_solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :team_id, null: false
      t.string :uuid, null: false
      t.bigint :exercise_id, null: false

      t.string :git_sha, null: false
      t.string :git_slug, null: false

      t.boolean :needs_feedback, null: false, default: false
      t.boolean :has_unseen_feedback, null: false, default: false
      t.integer :num_iterations, null: false, default: 0

      t.datetime :downloaded_at, null: true

      t.timestamps
    end

    add_index :team_solutions, [:user_id, :team_id, :exercise_id], unique: true
    add_foreign_key :team_solutions, :teams
    add_foreign_key :team_solutions, :users
    add_foreign_key :team_solutions, :exercises
  end
end
