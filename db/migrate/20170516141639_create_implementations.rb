class CreateImplementations < ActiveRecord::Migration[5.1]
  def change
    create_table :implementations do |t|
      t.bigint :track_exercise_id, null: false

      t.timestamps
    end

    add_foreign_key :implementations, :track_exercises
  end
end
