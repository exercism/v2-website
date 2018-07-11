class API::SolutionsController < APIController
  NUM_BYTES_IN_MEGABYTE = 1048576

  def show
    begin
      solution = SolutionBase.find_by_uuid!(params[:id])
    rescue
      return render_solution_not_found
    end

    unless current_user.may_view_solution?(solution)
      return render_403(:user_may_not_download_solution, "You may not download this solution")
    end

    responder = API::SolutionResponder.new(solution, current_user)
    solution.update(downloaded_at: Time.current) if current_user == solution.user
    render json: responder.to_hash
  end

  def latest
    if params[:team_id].present?
      begin
        team = Team.find(params[:team_id])
      rescue
        return render_404(:team_not_found, fallback_url: teams_url)
      end

      begin
        track = Track.find(params[:track_id])
        user_track = UserTrack.where(user: current_user, track: track).first
      rescue
        return render_404(:track_not_found, fallback_url: tracks_url)
      end

      begin
        exercise = track.exercises.find(params[:exercise_id])
      rescue
        return render_404(:exercise_not_found, fallback_url: track_url(track))
      end

      solution = TeamSolution.where(user_id: current_user.id, team_id: team.id, exercise_id: exercise.id).last!
    else
      if params[:track_id].present?
        begin
          track = Track.find(params[:track_id])
          user_track = UserTrack.where(user: current_user, track: track).first
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
          if current_user.may_unlock_exercise?(user_track, exercise)
            solution = CreatesSolution.create!(current_user, exercise)
          else
            return render_solution_not_found
          end
        end

      # No track id provided
      else
        solutions = current_user.solutions.joins(:exercise).where("exercises.slug": params[:exercise_id]).includes(exercise: :track)
        if solutions.size == 1
          solution = solutions.first

        elsif solutions.size > 1
          return render_error(400, :track_ambiguous, "Please specify a track id", possible_track_ids: solutions.flat_map {|s|s.exercise.track.slug}.uniq)

        else
          exercises = Exercise.side.where(unlocked_by: nil).where(track_id: current_user.tracks).where(slug: params[:exercise_id]).includes(:track)
          if exercises.size == 1
            solution = CreatesSolution.create!(current_user, exercises.first)
          elsif exercises.size == 0
            return render_404(:exercise_not_found)
          elsif exercises.size > 1
            return render_error(400, :track_ambiguous, "Please specify a track id", possible_track_ids: solutions.flat_map {|s|s.exercise.track.slug}.uniq)
          end
        end
      end
    end

    responder = API::SolutionResponder.new(solution, current_user)
    solution.update(downloaded_at: Time.current)
    render json: responder.to_hash
  end

  def update
    begin
      solution = SolutionBase.find_by_uuid!(params[:id], current_user.id)
    rescue
      # This covers both a non-existing solution and a solution
      # belonging to someone else. We might want seperate messages
      # but I'm choosing not to leak the existance of a solution
      # at this stage, but unifying the errors.
      return render_solution_not_found
    end

    params[:files].each do |file|
      if file.size.to_f > NUM_BYTES_IN_MEGABYTE
        return render_error(400, :file_too_large, "#{file.original_filename} is too large")
      end
    end

    begin
      CreatesIteration.create!(solution, params[:files])
    rescue DuplicateIterationError
      return render_error(400, :duplicate_iteration, "No files have changed since your last attempt")
    end

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
