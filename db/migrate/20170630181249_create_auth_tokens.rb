class CreateAuthTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_tokens do |t|
      t.bigint :user_id, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_foreign_key :auth_tokens, :users
  end
end
