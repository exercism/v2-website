class CreateCommunicationPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :communication_preferences do |t|
      t.bigint :user_id, null: false

      t.boolean :email_on_new_discussion_post, null: false, default: true

      t.timestamps
    end

    add_foreign_key :communication_preferences, :users
  end
end
