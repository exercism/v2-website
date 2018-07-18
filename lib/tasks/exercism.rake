namespace :exercism do
  desc 'Initiate exercism website'
  task :setup => :environment do
    identity_file = Rails.root.join 'server_identity'
    File.write identity_file, 'host' unless File.exists? identity_file
    %w(db:migrate yarn:install git:update_repos).each do |task|
      Rake::Task[task].invoke
    end
  end
end
