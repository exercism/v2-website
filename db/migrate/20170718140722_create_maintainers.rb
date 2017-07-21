class CreateMaintainers < ActiveRecord::Migration[5.1]
  def change
    create_table :maintainers do |t|
      t.bigint :track_id, null: false
      t.bigint :user_id, null: true
      t.string :name, null: false
      t.string :avatar_url, null: false
      t.string :github_username, null: false
      t.string :link_text
      t.string :link_url
      t.text :bio
      t.boolean :active, null: false, default: true
      t.boolean :visible, null: false, default: true

      t.timestamps
    end

    add_foreign_key :maintainers, :tracks
    add_foreign_key :maintainers, :users
  end
end
