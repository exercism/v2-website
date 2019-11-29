class Research::UserExperiment < ApplicationRecord
  belongs_to :user
  belongs_to :experiment

  def to_param
    experiment.slug
  end
end
