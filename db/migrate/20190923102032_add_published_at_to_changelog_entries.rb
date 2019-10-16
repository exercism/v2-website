class AddPublishedAtToChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :changelog_entries, :published_at, :datetime
  end
end
