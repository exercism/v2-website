class AddActiveColumnToTracks < ActiveRecord::Migration[5.1]
  def change
    add_column :tracks, :active, :boolean, default: true, null: false
  end
end
