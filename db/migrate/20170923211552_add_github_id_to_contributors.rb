class AddGithubIdToContributors < ActiveRecord::Migration[5.1]
  def change
    add_column :contributors, :github_id, :integer
  end
end
