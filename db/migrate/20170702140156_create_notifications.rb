class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.bigint :user_id

      t.string :about_type, null: true
      t.bigint :about_id, null: true

      t.text :content, null: true
      t.text :link, null: true

      t.timestamps
    end

    add_foreign_key :notifications, :users
  end
end
