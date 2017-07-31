class API::SolutionResponder
  include Rails.application.routes.url_helpers

  attr_reader :solution, :requester
  def initialize(solution, requester)
    @solution = solution
    @requester = requester
  end

  def to_hash
    {
      solution: {
        id: solution.id,
        user: {
          handle: user_handle,
          is_requester: solution.user_id == requester.id
        },
        exercise: {
          id: solution.exercise.id,
          instructions_url: instructions_url,
          track: {
            id: solution.exercise.track.slug
          }
        },
        files: files,
        iteration: iteration_hash
      }
    }
  end

  def user_handle
    user_track = UserTrack.where(track: solution.exercise.track, user: solution.user).first
    if user_track.anonymous?
      user_track.handle
    else
      solution.user.handle
    end
  end

  def instructions_url
    routes = Rails.application.routes.url_helpers
    routes.my_solution_url(solution)
  end

  # TODOGIT - Populate this.
  def files
    []
  end

  def iteration_hash
    iteration = solution.iterations.last
    return nil unless iteration

    {
      submitted_at: iteration.created_at
    }
  end
end
