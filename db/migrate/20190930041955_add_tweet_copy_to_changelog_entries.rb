class AddTweetCopyToChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :changelog_entries, :tweet_copy, :text
  end
end
