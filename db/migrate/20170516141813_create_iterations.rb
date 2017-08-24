class CreateIterations < ActiveRecord::Migration[5.1]
  def change
    create_table :iterations do |t|
      t.bigint :solution_id, null: false

      t.timestamps
    end

    add_foreign_key :iterations, :solutions
  end
end
