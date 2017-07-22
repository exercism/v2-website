class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :repo_url, null: false

      t.text :introduction, null: false
      t.text :about, null: false
      t.text :code_sample, null: false

      t.timestamps
    end
  end
end
