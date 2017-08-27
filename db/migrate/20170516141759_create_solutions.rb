class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.bigint :user_id, null: false
      t.string :uuid, null: false
      t.bigint :exercise_id, null: false
      t.string :git_sha, null: false
      t.string :git_slug, null: false

      t.bigint :approved_by_id, null: true
      t.datetime :downloaded_at, null: true
      t.datetime :completed_at, null: true
      t.datetime :published_at, null: true

      t.datetime :last_updated_by_user_at, null: true
      t.datetime :last_updated_by_mentor_at, null: true
      t.integer :num_mentors, null: false, default: 0
      t.integer :num_reactions, null: false, default: 0

      t.text :reflection, null: true

      t.boolean :is_legacy, null: false, default: false

      t.timestamps
    end

    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :exercises
    add_foreign_key :solutions, :users, column: :approved_by_id
  end
end
