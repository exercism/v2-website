class CreateTrackUpdateFetches < ActiveRecord::Migration[5.1]
  def change
    create_table :track_update_fetches do |t|
      t.timestamp :completed_at
      t.belongs_to :track_update, foreign_key: true, null: false
      t.string :host, null: false

      t.timestamps
    end

    add_index :track_update_fetches, [:track_update_id, :host], unique: true
  end
end
