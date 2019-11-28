class AddIndexForPolymorphicSubmissionSolution < ActiveRecord::Migration[6.0]
  def change
    add_index :submissions, [:solution_type, :solution_id]
  end
end
