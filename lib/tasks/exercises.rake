namespace :exercises do
  desc "Update exercise median wait times"
  task :update_median_wait_time => :environment do
    ExerciseServices::UpdateMedianWaitTime.()
  end
end
