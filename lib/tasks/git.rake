namespace :git do
  task :update_repos => :environment do
    Git::UpdatesRepos.update
  end

  task :sync => :environment do
    trap('SIGINT') { puts "Sync Processor interrupted"; exit }
    trap('SIGTERM') { puts "Sync Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::SyncsUpdatedRepos.run
  end

  task :fetch => :environment do
    trap('SIGINT') { puts "Fetch Processor interrupted"; exit }
    trap('SIGTERM') { puts "Fetch Processor terminated"; exit }
    Rails.logger = Logger.new(STDOUT)
    Git::FetchesUpdatedRepos.run
  end
end
