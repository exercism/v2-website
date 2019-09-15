set :stage, :production

server 'web1.exercism.io', user: fetch(:application), roles: %w{app web db git_fetch}
server 'web2.exercism.io', user: fetch(:application), roles: %w{app web db git_fetch}
server 'processor.exercism.io', user: fetch(:application), roles: %w{app assets web db processor git_sync}

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

namespace :assets do
  task :upload do
    on roles(:assets), in: :groups, limit: 1, wait: 10 do
      execute "aws s3 sync --acl=public-read /opt/exercism/current/public/assets/ s3://exercism-assets/assets/"
    end
  end
end

namespace :processors do
  task :restart do
    on roles(:processor) do
      execute "sudo /usr/sbin/service mentors_remind_overdue restart"
      execute "sudo /usr/sbin/service mentors_abandon_overdue restart"
      execute "sudo /usr/sbin/service analyzed_iterations_listener restart"
    end
  end
end

namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop do
    on roles(:processor) do
      execute "sudo systemctl stop exercism_delayedjob"
    end
  end

  desc "Start the delayed_job process"
  task :start do
    on roles(:processor) do
      execute "sudo systemctl start exercism_delayedjob"
    end
  end

  desc "Restart the delayed_job process"
  task :restart do
    on roles(:processor) do
      execute "sudo systemctl restart exercism_delayedjob"
    end
  end
end

after "deploy:assets:precompile", "assets:upload"

after "deploy:published", "delayed_job:restart"
after "deploy:published", "git_sync:restart"
after "deploy:published", "puma_service:restart"
after "deploy:published", "processors:restart"
