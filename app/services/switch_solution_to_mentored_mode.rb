class SwitchSolutionToMentoredMode
  include Mandate

  attr_reader :solution
  def initialize(solution)
    @solution = solution
  end

  def call
    return if user_track.mentoring_allowance_used_up?

    solution.update(
      independent_mode: false,
      completed_at: nil,
      published_at: nil,
      approved_by: nil,
      last_updated_by_user_at: Time.now,
      updated_at: Time.now
    )
  end

  private

  def user_track
    solution.user.user_track_for(solution.track)
  end
end
