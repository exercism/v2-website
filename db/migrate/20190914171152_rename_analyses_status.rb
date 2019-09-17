class RenameAnalysesStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :iteration_analyses, :status, :ops_status
  end
end
