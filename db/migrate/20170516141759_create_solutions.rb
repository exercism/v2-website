class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :exercise_id, null: false
      t.integer :status, null: false, default: 0

      t.bigint :approved_by_mentor_id, null: true
      t.datetime :completed_at, null: true

      t.timestamps
    end

    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :exercises
    add_foreign_key :solutions, :users, column: :approved_by_mentor_id
  end
end
