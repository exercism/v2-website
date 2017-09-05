class CreateRepoUpdate < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_updates do |t|
      t.timestamp :synced_at
      t.string :slug, null: false

      t.timestamps
    end
  end
end
