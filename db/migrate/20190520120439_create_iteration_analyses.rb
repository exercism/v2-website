class CreateIterationAnalyses < ActiveRecord::Migration[5.2]
  def change
    create_table :iteration_analyses do |t|
      t.bigint :iteration_id, null: false
      t.string :status, null: false
      t.json :analysis, null: true

      t.timestamps

      t.foreign_key :iterations
    end
  end
end
