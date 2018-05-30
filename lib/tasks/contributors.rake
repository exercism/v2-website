namespace :contributors do
  task :sync => :environment do
    SyncsContributors.sync!("/opt/exercism-contributors/contributors.json")
  end
end
