class CreateChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :changelog_entries do |t|
      t.belongs_to :created_by, null: false
      t.string :title, null: false
      t.text :details_markdown
      t.references :referenceable, polymorphic: true, index: { name: "index_changelog_entries_on_referenceable" }
      t.string :info_url

      t.timestamps
    end
  end
end
