class AllowTestRunnerVersionSlugToBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :infrastructure_test_runners, :version_slug, true
  end
end
