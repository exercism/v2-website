class CreateExerciseTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_topics do |t|
      t.bigint :exercise_id, null: false
      t.bigint :topic_id, null: false

      t.timestamps
    end

    add_foreign_key :exercise_topics, :exercises
    add_foreign_key :exercise_topics, :topics
  end
end
