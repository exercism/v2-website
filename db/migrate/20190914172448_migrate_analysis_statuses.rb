class MigrateAnalysisStatuses < ActiveRecord::Migration[5.2]
  def change
    IterationAnalysis.find_each do |ia|
      ia.update!(analysis_status: ia.analysis[:status])
    end
  end
end
