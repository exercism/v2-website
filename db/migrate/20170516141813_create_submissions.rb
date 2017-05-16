class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.bigint :user_implementation_id, null: false

      t.timestamps
    end

    add_foreign_key :submissions, :user_implementations
  end
end
