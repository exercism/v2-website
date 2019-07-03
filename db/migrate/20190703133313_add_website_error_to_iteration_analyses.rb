class AddWebsiteErrorToIterationAnalyses < ActiveRecord::Migration[5.2]
  def change
    add_column :iteration_analyses, :website_error, :string, null: true
  end
end
