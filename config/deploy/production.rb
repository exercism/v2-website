set :stage, :production

server 'web1.exercism.local', user: fetch(:application), roles: %w{app web db}

namespace :puma_service do
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service #{fetch(:application)} restart"
    end
  end
end

namespace :sidekiq do
  task :shutdown do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "kill -TERM `cat /opt/exercism/current/tmp/pids/sidekiq.pid`"
    end
  end
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service exercism-sidekiq restart"
    end
  end
end

after "deploy:starting", "sidekiq:shutdown"

after "deploy:published", "puma_service:restart"
after "deploy:published", "sidekiq:restart"
