namespace :git do
  task :update_repos => :environment do
    Git::UpdateRepos.()
  end

  task :sync => :environment do
    trap('SIGINT') { puts "Sync Processor interrupted"; exit }
    trap('SIGTERM') { puts "Sync Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::SyncUpdatedRepos.run
  end

  task :fetch => :environment do
    trap('SIGINT') { puts "Fetch Processor interrupted"; exit }
    trap('SIGTERM') { puts "Fetch Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::FetchUpdatedRepos.run
  end
end
