class AddDetailsHtmlToChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :changelog_entries, :details_html, :text
  end
end
