namespace :git do
  task :repo_syncer => :environment do
    trap('SIGINT') { puts "Processor interrupted"; exit }
    trap('SIGTERM') { puts "Processor terminated"; exit }

    Git::SyncsTracks.sync
  end
end
