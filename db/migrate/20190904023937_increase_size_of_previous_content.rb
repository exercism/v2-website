class IncreaseSizeOfPreviousContent < ActiveRecord::Migration[5.2]
  def change
    change_column :discussion_posts, :previous_content, "LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
  end
end
