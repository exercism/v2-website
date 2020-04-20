class AddShowV3PatienceModalToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :show_v3_patience_modal, :boolean, default: true, null: false
  end
end
