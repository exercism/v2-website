class CreateSolutionMentorships < ActiveRecord::Migration[5.1]
  def change
    create_table :solution_mentorships do |t|
      t.bigint :user_id
      t.bigint :solution_id

      t.boolean :abandoned, null: false, default: false
      t.boolean :requires_action, null: false, default: false

      t.integer :rating, null: true
      t.text :feedback, null: true
      t.boolean :show_feedback_to_mentor, null: true

      t.timestamps
    end

    add_foreign_key :solution_mentorships, :users
    add_foreign_key :solution_mentorships, :solutions
  end
end
