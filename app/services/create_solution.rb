class CreateSolution
  include Mandate

  initialize_with :user, :exercise

  def call
    Solution.create!(
      user: user,
      exercise: exercise,
      git_sha: git_sha,
      git_slug: exercise.slug,
      last_updated_by_user_at: Time.current,
      track_in_independent_mode: independent_mode
    )
  rescue ActiveRecord::RecordNotUnique
    Solution.find_by(user: user, exercise: exercise)
  end

  private

  memoize
  def git_sha
    Git::ExercismRepo.current_head(repo_url)
  end

  memoize
  def repo_url
    exercise.track.repo_url
  end

  memoize
  def user_track
    UserTrack.find_by!(user_id: user, track_id: exercise.track_id)
  end

  def independent_mode
    !!user_track.independent_mode
  end
end
