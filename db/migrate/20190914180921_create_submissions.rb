class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.bigint :solution_id, null: false
      t.boolean :tested, null: false, default: false

      t.timestamps

      t.index [:tested, :id]
      t.index [:solution_id, :id]

      t.foreign_key :solutions
    end
  end
end
