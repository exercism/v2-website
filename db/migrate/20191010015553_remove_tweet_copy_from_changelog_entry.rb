class RemoveTweetCopyFromChangelogEntry < ActiveRecord::Migration[5.2]
  def change
    remove_column :changelog_entries, :tweet_copy, :text
  end
end
