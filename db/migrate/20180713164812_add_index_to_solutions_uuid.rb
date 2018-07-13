class AddIndexToSolutionsUuid < ActiveRecord::Migration[5.2]
  def change
    add_index :solutions, :uuid
  end
end
