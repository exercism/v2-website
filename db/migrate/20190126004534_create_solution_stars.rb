class CreateSolutionStars < ActiveRecord::Migration[5.2]
  def change
    create_table :solution_stars do |t|
      t.bigint :solution_id, null: false
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_index :solution_stars, [:solution_id, :user_id], unique: true
    add_index :solution_stars, :user_id
  end
end
