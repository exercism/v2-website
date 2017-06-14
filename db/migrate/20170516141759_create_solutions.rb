class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :exercise_id, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :exercises
  end
end
