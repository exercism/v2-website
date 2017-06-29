class CreateIterations < ActiveRecord::Migration[5.1]
  def change
    create_table :iterations do |t|
      t.bigint :solution_id, null: false
      t.column :code, "LONGTEXT", null: false

      t.integer :mentor_status, null: false, default: 0

      t.timestamps
    end

    add_foreign_key :iterations, :solutions
  end
end
