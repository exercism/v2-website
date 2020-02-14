module Research
  class CreateSolution
    include Mandate

    initialize_with :user, :experiment, :exercise

    def call

      atomic do
        ExperimentSolution.find_or_create_by(
          user: user,
          experiment: experiment,
          exercise: exercise
        ) do |solution|
          solution.git_sha = git_sha
          solution.git_slug = exercise.slug
        end
      end
    end

    private

    def atomic
      yield
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def git_sha
      Git::ExercismRepo.current_head(repo_url)
    end

    def repo_url
      exercise.track.repo_url
    end
  end
end
