class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.bigint :user_id, null: false
      t.string :display_name, null: false
      t.string :slug, null: false

      t.string :twitter, null: true
      t.string :website, null: true
      t.string :github, null: true
      t.string :linkedin, null: true
      t.string :medium, null: true

      t.timestamps
    end

    add_index :profiles, :slug, unique: true
    add_foreign_key :profiles, :users
  end
end
