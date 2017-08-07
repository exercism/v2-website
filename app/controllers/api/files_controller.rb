class API::FilesController < APIController
  def show
    # TODO - Check permissions here

    begin
      @solution = Solution.find_by_uuid!(params[:solution_id])
    rescue
      return render json: { error: "Solution not found" }, status: 404
    end

    # TODO I had to manually add the '.cs' extension here
    @file_path = params[:id] + ".cs"

    begin
      @content = exercise_reader.read_file(@file_path)
    rescue
      return render json: { error: "File not found" }, status: 404
    end

    if @content.nil?
      return render json: { error: "File not found" }, status: 404
    end

    render plain:  @content
  end

  private

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
