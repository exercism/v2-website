class API::SolutionsController < APIController
  def latest
    begin
      track = Track.find(params[:track_id])
    rescue
      return render json: {error: "Track not found", fallback_url: tracks_url}, status: 404
    end

    begin
      exercise = track.exercises.find(params[:exercise_id])
    rescue
      return render json: {error: "Exercise not found", fallback_url: track_url(track)}, status: 404
    end

    solution = exercise.solutions.last
    return head 404 unless solution

    unless current_user == solution.user ||
           solution.published? ||
           current_user.mentoring_track?(track)
      return render json: {}, status: 403
    end

    responder = API::SolutionResponder.new(solution, current_user)
    render json: responder.to_hash
  end

  def update
    solution = current_user.solutions.find(params[:id])
    render json: {}, status: 403 and return unless solution

    CreatesIteration.create!(solution, params[:code])

    render json: {}, status: 201
  end

  private

  def set_track
    @track = Track.find_by!(slug: params[:track_id])
  end

  def set_exercise
    @exercise = @track.exercises.find_by!(slug: params[:exercise_id])
  end
end
