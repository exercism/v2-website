class CreateReactions < ActiveRecord::Migration[5.1]
  def change
    create_table :reactions do |t|
      t.bigint :solution_id, null: false
      t.bigint :user_id, null: false

      t.integer :emotion, null: false
      t.text :comment, null: true

      t.timestamps
    end

    change_column :reactions, :comment, "TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"

    add_foreign_key :reactions, :solutions
    add_foreign_key :reactions, :users
  end
end
