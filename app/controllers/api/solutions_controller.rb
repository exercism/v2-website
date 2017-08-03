class API::SolutionsController < APIController
  NUM_BYTES_IN_MEGABYTE = 1048576

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
    begin
      solution = current_user.solutions.find(params[:id])
    rescue
      # This covers both a non-existing solution and a solution
      # belonging to someone else. We might want seperate messages
      # but I'm choosing not to leak the existance of a solution
      # at this stage, but unifying the errors.
      return render json: {error: "Solution not found"}, status: 404
    end

    params[:files].each do |file|
      if file.size.to_f > NUM_BYTES_IN_MEGABYTE
        return render json: {error: "#{file.original_filename} is too large"}, status: 404
      end
    end

    iteration = CreatesIteration.create!(solution, params[:files])

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
