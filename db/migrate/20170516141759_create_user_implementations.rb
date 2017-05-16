class CreateUserImplementations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_implementations do |t|
      t.bigint :user_id, null: false
      t.bigint :implementation_id, null: false

      t.timestamps
    end

    add_foreign_key :user_implementations, :users
    add_foreign_key :user_implementations, :implementations
  end
end
