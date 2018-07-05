set :stage, :production

server 'web1.exercism.io', user: fetch(:application), roles: %w{app web db git_fetch}
server 'web2.exercism.io', user: fetch(:application), roles: %w{app web db git_fetch}
server 'processor.exercism.io', user: fetch(:application), roles: %w{app web db processor git_sync}

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

namespace :sidekiq do
  task :shutdown do
    on roles(:processor), in: :groups, limit: 3, wait: 10 do
      execute "[ -e /opt/exercism/current/tmp/pids/sidekiq.pid ] && kill -TERM `cat /opt/exercism/current/tmp/pids/sidekiq.pid`; exit 0"
    end
  end
  task :restart do
    on roles(:processor), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service exercism-sidekiq restart"
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

after "deploy:starting", "sidekiq:shutdown"
after "deploy:published", "puma_service:restart"
after "deploy:published", "sidekiq:restart"
after "deploy:published", "git_sync:restart"
after "deploy:failed", "sidekiq:restart"
