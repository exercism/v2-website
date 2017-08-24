class AddLegacyToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :is_legacy, :boolean, null: false, default: false
  end
end
