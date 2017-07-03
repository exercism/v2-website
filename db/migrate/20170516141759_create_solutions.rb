class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :exercise_id, null: false
      t.string :git_sha, null: false

      t.bigint :approved_by_id, null: true
      t.datetime :completed_at, null: true

      t.text :notes, null: true

      t.timestamps
    end

    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :exercises
    add_foreign_key :solutions, :users, column: :approved_by_id
  end
end
