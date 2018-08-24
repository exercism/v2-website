namespace :temporary do
  desc "Bootstrap users without auth tokens"
  task :bootstrap_users => :environment do
    users_without_auth_tokens = User.where.not(id: AuthToken.select(:user_id))

    users_without_auth_tokens.each { |user| BootstrapUser.(account) }
  end
end
