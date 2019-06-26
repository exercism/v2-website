class AddTypeToDiscussionPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :discussion_posts, :type, :string, null: true
  end
end
