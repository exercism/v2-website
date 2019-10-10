class CreateChangelogEntryTweet < ActiveRecord::Migration[5.2]
  def change
    create_table :changelog_entry_tweets do |t|
      t.belongs_to :changelog_entry, null: false
      t.text :copy, null: false
    end
  end
end
