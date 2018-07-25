class AddDeletedToDiscussionPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :discussion_posts, :deleted, :boolean, null: false, default: false
  end
end
