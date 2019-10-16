class AddStatusToChangelogEntryTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :changelog_entry_tweets, :status, :integer, default: 0, null: false
  end
end
