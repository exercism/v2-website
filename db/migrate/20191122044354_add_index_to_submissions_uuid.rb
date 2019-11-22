class AddIndexToSubmissionsUuid < ActiveRecord::Migration[6.0]
  def change
    add_index :submissions, :uuid, unique: true
  end
end
