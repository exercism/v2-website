class AddEmailFlagsForUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :accepted_privacy_policy_at, :datetime
    add_column :users, :accepted_terms_at, :datetime
    add_column :communication_preferences, :receive_product_updates, :boolean, null: false, default: true
  end
end
