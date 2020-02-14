class CreateResearchExperimentSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :research_experiment_solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :experiment_id, null: false
      t.string :uuid, null: false
      t.bigint :exercise_id, null: false
      t.string :git_sha, null: false
      t.string :git_slug, null: false

      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
      t.foreign_key :users
      t.foreign_key :exercises
      t.foreign_key :research_experiments, column: :experiment_id
    end
  end
end
