class AllowNoUsersForDiscussionPosts < ActiveRecord::Migration[5.2]
  def change
    change_column_null :discussion_posts, :user_id, true
  end
end
