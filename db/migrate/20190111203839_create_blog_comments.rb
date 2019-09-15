class CreateBlogComments < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_comments do |t|
      t.bigint :blog_post_id, null: false
      t.bigint :user_id, null: false

      # For threaded comments
      t.bigint :blog_comment_id, null: true

      t.text :content, limit: 4294967295, null: false
      t.text :html, limit: 4294967295, null: false

      t.boolean :edited, default: false, null: false
      t.text :previous_content, null: true
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end

    add_foreign_key :blog_comments, :blog_posts
    add_foreign_key :blog_comments, :users
    add_foreign_key :blog_comments, :blog_comments
  end
end
