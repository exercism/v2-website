class AddReferenceableKeyToChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :changelog_entries, :referenceable_key, :string
  end
end
