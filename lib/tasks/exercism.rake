namespace :exercism do
  desc 'Initiate exercism website'
  task :setup => :environment do
    %w(db:migrate yarn:install git:update_repos).each do |task|
      Rake::Task[task].invoke
    end
  end
end
