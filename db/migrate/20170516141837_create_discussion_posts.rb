class CreateDiscussionPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :discussion_posts do |t|
      t.bigint :iteration_id, null: false
      t.bigint :user_id, null: false
      t.column :content, "LONGTEXT", null: false
      t.column :html, "LONGTEXT", null: false

      t.timestamps
    end

    add_foreign_key :discussion_posts, :iterations
  end
end
