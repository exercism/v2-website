class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :repo_url, null: false

      t.text :introduction, null: false
      t.text :about, null: false
      t.text :code_sample, null: false

      t.timestamp :git_synced_at
      t.timestamp :git_failed_at
      t.boolean :git_sync_required, null: false, default: true

      t.timestamps
    end
  end
end
