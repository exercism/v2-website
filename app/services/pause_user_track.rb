class PauseUserTrack
  include Mandate

  initialize_with :user_track

  def call
    user_track.update paused: true
    solution_ids = user_track.solutions.pluck(:id)
    SolutionMentorship.where(solution_id: solution_ids).
      update_all(paused: true)
  end
end
