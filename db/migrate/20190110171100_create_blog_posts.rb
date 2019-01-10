class CreateBlogPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_posts do |t|
      t.string :uuid, null: false
      t.string :slug, null: false
      t.string :category, null: false
      t.datetime :published_at, null: false

      t.string :title, null: false

      # The handle of the author. We can join this up
      # to a user at runtime and just display the handle
      # if a user with this handle doesn't exist
      t.string :author_handle, null: false

      # Copy for a tweet, facebook post, etc
      t.string :marketing_copy, null: true, limit: 280

      # The repository and filepath for the content
      t.string :content_repository, null: false
      t.string :content_filepath, null: false

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, :published_at
  end
end
