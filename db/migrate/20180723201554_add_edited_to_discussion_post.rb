class AddEditedToDiscussionPost < ActiveRecord::Migration[5.2]
  def change
    add_column :discussion_posts, :edited, :boolean, default: false, null: false
  end
end
