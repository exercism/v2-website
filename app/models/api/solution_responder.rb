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
        id: solution.uuid,
        url: solution_url,
        user: {
          handle: user_handle,
          is_requester: solution.user_id == requester.id
        },
        exercise: {
          id: solution.exercise.slug,
          instructions_url: instructions_url,
          track: {
            id: solution.exercise.track.slug,
            language: solution.exercise.track.title
          }
        },
        file_download_base_url: "https://api.exercism.io/v1/solutions/#{solution.uuid}/files/",
        #file_download_base_url: "http://3e4f0dc8.ngrok.io/api/v1/solutions/#{solution.uuid}/files/",
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

  def solution_url
    if solution.user == requester
      routes.my_solution_url(solution)
    elsif solution.published?
      routes.track_exercise_solution_url(solution.exercise.track, solution.exercise, solution)
    else
      routes.mentor_solution_url(solution)
    end
  end

  def instructions_url
    routes.my_solution_url(solution)
  end

  def files
    fs = Set.new(exercise_reader.files)
    fs += iteration.files.pluck(:filename) if iteration
    fs
  end

  def iteration_hash
    return nil unless iteration
    { submitted_at: iteration.created_at }
  end

  def iteration
    @iteration ||= solution.iterations.last
  end

  def routes
    @routes ||= Rails.application.routes.url_helpers
  end

  private

  def exercise_reader
    exercise_slug = solution.exercise.slug
    track_url = solution.exercise.track.repo_url
    Git::ExercismRepo.new(track_url).exercise(exercise_slug)
  end
end
