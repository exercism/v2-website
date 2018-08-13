class AddPreviousContentForDiscussionPost < ActiveRecord::Migration[5.2]
  def change
    add_column :discussion_posts, :previous_content, :text
  end
end
