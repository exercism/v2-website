set :stage, :production
set :rails_env, :staging
set :branch, 'mentors'

# TODO cap file should write /opt/exercism/rails_env=staging

server 'ec2-34-247-238-198.eu-west-1.compute.amazonaws.com', user: fetch(:application), roles: %w{app web db git_fetch}
namespace :puma_service do
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service #{fetch(:application)} restart"
    end
  end
end

namespace :git_sync do
  task :restart do
    on roles(:git_fetch), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service exercism_git_fetch restart"
    end
    on roles(:git_sync), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service exercism_git_sync restart"
    end
  end
end

namespace :memcached do
  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service memcached restart"
    end
  end
end

after "deploy:published", "puma_service:restart"
after "deploy:published", "git_sync:restart"
