Git::RepoBase.configure do |config|
  config.repo_base_dir = Rails.application.config_for("repos")["base_dir"]
end

Git::ProblemSpecifications.configure do |config|
  config.repo_url = Rails.application.config_for("repos")["problem_specifications"]
end
