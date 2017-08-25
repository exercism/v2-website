class CreateIgnoredSolutionMentorships < ActiveRecord::Migration[5.1]
  def change
    create_table :ignored_solution_mentorships do |t|
      t.bigint :solution_id, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_foreign_key :ignored_solution_mentorships, :users
    add_foreign_key :ignored_solution_mentorships, :solutions
  end
end
