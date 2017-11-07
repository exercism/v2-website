class AddMentoringEnabledToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :mentoring_enabled, :boolean, null: true
  end
end
