class AddActiveToAuthToken < ActiveRecord::Migration[5.2]
  def change
    add_column :auth_tokens, :active, :boolean, null: false, default: true
    add_index :auth_tokens, [:user_id, :active]
  end
end
