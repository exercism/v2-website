class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.bigint :user_id, null: false
      t.bigint :implementation_id, null: false

      t.timestamps
    end

    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :implementations
  end
end
