class MakeSubmissionSolutionPolymorphic < ActiveRecord::Migration[6.0]
  def change
    add_column :submissions, :solution_type, :string, null: true
    Submission.update_all(solution_type: "Solution")
    change_column_null :submissions, :solution_type, false
  end
end
