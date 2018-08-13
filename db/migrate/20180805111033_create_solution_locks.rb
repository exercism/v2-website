class CreateSolutionLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :solution_locks do |t|
      t.bigint :solution_id, null: false
      t.bigint :user_id, null: false
      t.datetime :locked_until, null: false

      t.timestamps
    end

    add_foreign_key :solution_locks, :solutions
    add_foreign_key :solution_locks, :users
  end
end
