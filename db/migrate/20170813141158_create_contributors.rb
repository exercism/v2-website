class CreateContributors < ActiveRecord::Migration[5.1]
  def change
    create_table :contributors do |t|
      t.string :github_username, null: false
      t.string :avatar_url, null: false
      t.integer :num_contributions, null: false

      t.boolean :is_maintainer, null: false, default: false
      t.boolean :is_core, null: false, default: false

      t.timestamps
    end

    add_index :contributors, [:is_maintainer, :is_core, :num_contributions], name: "main_find_idx"
  end
end
