class DisallowNullGithubIdsForContributors < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:contributors, :github_id, false)
  end
end
