namespace :contributors do
  task :sync => :environment do
    SyncsContributors.sync!(Rails.root / "../contributors/contributors.json")
  end
end
