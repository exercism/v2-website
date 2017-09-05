class CreateRepoUpdateFetches < ActiveRecord::Migration[5.1]
  def change
    create_table :repo_update_fetches do |t|
      t.timestamp :completed_at
      t.belongs_to :repo_update, foreign_key: true, null: false
      t.string :host, null: false

      t.timestamps
    end

    add_index :repo_update_fetches, [:repo_update_id, :host], unique: true
  end
end
