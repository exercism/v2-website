class API::FilesController < APIController
  def show
    begin
      @solution = Solution.find_by_uuid!(params[:solution_id])
    rescue
      return render_solution_not_found
    end

    unless current_user.may_view_solution?(@solution)
      return render_403(:user_may_not_download_solution, "You may not download this solution")
    end

    begin
      content = exercise_reader.read_file(params[:filepath])
    rescue
      return render_file_not_found
    end

    return render_file_not_found unless content

    render plain:  content
  end

  private

  def render_file_not_found
    render_404(:file_not_found)
  end


  def exercise_reader
    @exercise_reader ||= Git::ExercismRepo.new(track_url).exercise(exercise_slug)
  end

  def exercise
    @exercise ||= @solution.exercise
  end

  def exercise_slug
    @exercise_slug ||= @solution.exercise.slug
  end

  def track_url
    @track_url ||= exercise.track.repo_url
  end
end
