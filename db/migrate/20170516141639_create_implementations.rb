class CreateImplementations < ActiveRecord::Migration[5.1]
  def change
    create_table :implementations do |t|
      t.bigint :exercise_id, null: false

      t.timestamps
    end

    add_foreign_key :implementations, :exercises
  end
end
