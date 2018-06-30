class RemoveAboutFromTracks < ActiveRecord::Migration[5.1]
  def up
    remove_column :tracks, :about
  end

  def down
    add_column :tracks, :about, :string
  end
end
