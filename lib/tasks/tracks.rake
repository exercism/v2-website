namespace :tracks do
  desc "Update track median wait times"
  task :update_median_wait_time => :environment do
    TrackServices::UpdateMedianWaitTime.()
  end
end
