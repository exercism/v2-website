class RemoveOldMentoringEnabledFlag < ActiveRecord::Migration[5.2]
  def change
    #remove_column :solutions, :mentoring_enabled, :boolean, null: true
  end
end
