class API::SolutionsController < APIController
  NUM_BYTES_IN_MEGABYTE = 1048576

  def show
    begin
      solution = Solution.find_by_uuid!(params[:id])
    rescue
      return render_solution_not_found
    end

    unless current_user.may_view_solution?(solution)
      return render_403(:user_may_not_download_solution, "You may not download this solution")
    end

    responder = API::SolutionResponder.new(solution, current_user)
    solution.update(downloaded_at: DateTime.now) if current_user == solution.user
    render json: responder.to_hash
  end

  def latest
    if params[:track_id].present?
      begin
        track = Track.find(params[:track_id])
      rescue
        return render_404(:track_not_found, fallback_url: tracks_url)
      end

      begin
        exercise = track.exercises.find(params[:exercise_id])
      rescue
        return render_404(:exercise_not_found, fallback_url: track_url(track))
      end

      begin
        solution = current_user.solutions.where(exercise_id: exercise.id).last!
      rescue
        return render_solution_not_found
      end

    # No track id provided
    else
      solutions = current_user.solutions.joins(:exercise).where("exercises.slug": params[:exercise_id]).includes(exercise: :track)
      if solutions.size == 0
        return render_404(:exercise_not_found)
      elsif solutions.size > 1
        return render_error(400, :track_ambiguous, "Please specify a track id", possible_track_ids: solutions.flat_map {|s|s.exercise.track.slug}.uniq)
      else
        solution = solutions.first
      end
    end

    responder = API::SolutionResponder.new(solution, current_user)
    solution.update(downloaded_at: DateTime.now)
    render json: responder.to_hash
  end

  def update
    begin
      solution = current_user.solutions.find_by_uuid!(params[:id])
    rescue
      # This covers both a non-existing solution and a solution
      # belonging to someone else. We might want seperate messages
      # but I'm choosing not to leak the existance of a solution
      # at this stage, but unifying the errors.
      return render_solution_not_found
    end

    params[:files].each do |file|
      if file.size.to_f > NUM_BYTES_IN_MEGABYTE
        render_error(400, :file_too_large, "#{file.original_filename} is too large")
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
