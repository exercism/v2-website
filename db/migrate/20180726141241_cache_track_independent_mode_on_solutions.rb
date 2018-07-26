class CacheTrackIndependentModeOnSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :track_in_independent_mode, :boolean, null: false, default: false
  end
end
