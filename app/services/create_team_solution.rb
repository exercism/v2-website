class CreateTeamSolution
  include Mandate

  attr_reader :user, :team, :exercise
  def initialize(user, team, exercise)
    @user = user
    @team = team
    @exercise = exercise
  end

  def call
    unless TeamMembership.where(user: user, team: team).exists?
      raise TeamMembership::InvalidMembership
    end

    atomic do
      TeamSolution.find_or_create_by(
        user: user,
        team: team,
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
