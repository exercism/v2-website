class AddIndepdendentModeToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :independent_mode, :boolean, null: false, default: false
  end
end
