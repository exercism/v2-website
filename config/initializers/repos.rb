Git::RepoBase.configure do |config|
  config.repo_base_dir = Rails.application.config_for("repos")["base_dir"]
end
