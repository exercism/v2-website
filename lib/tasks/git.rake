namespace :git do
  task :sync => :environment do
    trap('SIGINT') { puts "Sync Processor interrupted"; exit }
    trap('SIGTERM') { puts "Sync Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::SyncsTracks.sync
  end

  task :fetch => :environment do
    trap('SIGINT') { puts "Fetch Processor interrupted"; exit }
    trap('SIGTERM') { puts "Fetch Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::FetchesUpdatedTracks.run
  end
end
