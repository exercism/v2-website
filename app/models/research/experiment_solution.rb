class Research::ExperimentSolution < ApplicationRecord
  include SolutionBase

  belongs_to :user
  belongs_to :exercise

  has_many :submissions, as: :solution

  def experiment_solution?
    true
  end
end
