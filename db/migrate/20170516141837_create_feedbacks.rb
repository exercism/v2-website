class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.bigint :submission_id, null: false

      t.timestamps
    end

    add_foreign_key :feedbacks, :submissions
  end
end
