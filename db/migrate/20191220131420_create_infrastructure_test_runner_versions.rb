class CreateInfrastructureTestRunnerVersions < ActiveRecord::Migration[6.0]
  def change
    rename_column :infrastructure_test_runners, :container_slug, :version_slug

    create_table :infrastructure_test_runner_versions do |t|
      t.bigint :test_runner_id, null: false
      t.string :slug, null: false
      t.integer :status, null: false, default: 0

      t.timestamps

      t.index :slug, unique: true
      t.foreign_key :infrastructure_test_runners, column: :test_runner_id
    end
  end
end
