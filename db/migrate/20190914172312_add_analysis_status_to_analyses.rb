class AddAnalysisStatusToAnalyses < ActiveRecord::Migration[5.2]
  def change
    add_column :iteration_analyses, :analysis_status, :string, null: true
  end
end
