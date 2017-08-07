class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :repo_url, null: false

      t.text :introduction, null: false
      t.text :about, null: false
      t.text :code_sample, null: false

      t.string :syntax_highligher_language, null: false

      t.string :bordered_green_icon_url, null: true
      t.string :bordered_turquoise_icon_url, null: true
      t.string :hex_green_icon_url, null: true
      t.string :hex_turquoise_icon_url, null: true
      t.string :hex_white_icon_url, null: true
      t.string :hex_green_icon_url, null: true

      t.timestamps
    end
  end
end
