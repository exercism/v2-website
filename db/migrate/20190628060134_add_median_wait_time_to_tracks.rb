class AddMedianWaitTimeToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :median_wait_time, :integer
  end
end
