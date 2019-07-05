class AddMedianWaitTimeToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :median_wait_time, :integer
  end
end
