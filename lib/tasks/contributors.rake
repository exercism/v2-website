namespace :contributors do
  task :sync => :environment do
    SyncContributors.("/opt/exercism-contributors/contributors.json")
  end
end
