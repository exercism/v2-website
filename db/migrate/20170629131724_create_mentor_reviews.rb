class CreateMentorReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :mentor_reviews do |t|
      t.bigint :user_id, null: false
      t.bigint :mentor_id, null: false
      t.bigint :solution_id, null: false

      t.integer :rating, null: false
      t.text :feedback, null: true

      t.boolean :show_to_mentor, null: false, default: false

      t.timestamps
    end

    add_foreign_key :mentor_reviews, :users, column: :user_id
    add_foreign_key :mentor_reviews, :users, column: :mentor_id
    add_foreign_key :mentor_reviews, :solutions
  end
end
