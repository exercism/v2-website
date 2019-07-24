class AddDeletedAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deleted_at, :datetime
  end
end
