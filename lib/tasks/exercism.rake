namespace :exercism do
  desc 'Initiate exercism website'
  task :setup => :environment do
    %w(yarn:install db:schema:load db:seed).each do |task|
      Rake::Task[task].invoke
    end
  end
end
