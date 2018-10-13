class UnpauseUserTrack
  include Mandate

  initialize_with :user_track

  def call
    user_track.update paused: false
    solution_ids = user_track.solutions.pluck(:id)
    SolutionMentorship.
      update_all(paused: false)
  end
end
