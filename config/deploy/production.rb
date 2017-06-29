set :stage, :production

server 'web1.exercism.local', user: fetch(:application), roles: %w{app web db}

namespace :puma_service do
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo /usr/sbin/service #{fetch(:application)} restart"
    end
  end
end

after "deploy:published", "puma_service:restart"
