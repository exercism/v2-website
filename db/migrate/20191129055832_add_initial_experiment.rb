class AddInitialExperiment < ActiveRecord::Migration[6.0]
  def change
    Research::Experiment.create!(
      title: "How does what you know affect how you code?",
      repo_url: "https://github.com/exercism/research_experiment_1"
    )
  end
end
