class CreateInfrastructureTestRunners < ActiveRecord::Migration[6.0]
  def change
    create_table :infrastructure_test_runners do |t|
      t.string :language_slug, null: false
      t.integer :timeout_ms, null: false
      t.string :container_slug, null: false
      t.integer :num_processors, null: false

      t.timestamps
    end
  end
end
