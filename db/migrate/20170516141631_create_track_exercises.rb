class CreateTrackExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :track_exercises do |t|
      t.bigint :track_id, null: false
      t.bigint :exercise_id, null: false

      t.timestamps
    end

    add_foreign_key :track_exercises, :tracks
    add_foreign_key :track_exercises, :exercises
  end
end
