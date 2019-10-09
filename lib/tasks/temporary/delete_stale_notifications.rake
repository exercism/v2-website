namespace :temporary do
  desc "Delete stale notifications about solutions and iterations"
  task :delete_stale_notifications => :environment do
    puts "Deleting notifications...."

    Temporary::DeleteStaleNotificationsTask.()

    puts "Done"
  end
end
