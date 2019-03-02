class CreateUserEmailLogs < ActiveRecord::Migration[5.2]
  def up
    create_table :user_email_logs do |t|
      t.bigint :user_id, null: false
      t.datetime :mentor_heartbeat_sent_at, null: true

      t.timestamps
    end

    add_foreign_key :user_email_logs, :users
    add_index :user_email_logs, :user_id, unique: true
  end

  def down
    drop_table :user_email_logs
  end
end
