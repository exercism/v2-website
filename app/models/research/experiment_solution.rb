class Research::ExperimentSolution < ApplicationRecord
  include SolutionBase

  belongs_to :user
  belongs_to :experiment

  has_many :submissions, as: :solution

  def research_experiment_solution?
    true
  end
end
