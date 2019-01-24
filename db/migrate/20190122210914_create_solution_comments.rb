class CreateSolutionComments < ActiveRecord::Migration[5.2]
  def change
    create_table :solution_comments do |t|
      t.bigint :solution_id, null: false
      t.bigint :user_id, null: false
      t.text :content, limit: 4294967295, null: false
      t.text :html, limit: 4294967295, null: false
      t.boolean :edited, default: false, null: false
      t.text :previous_content, null: true
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
