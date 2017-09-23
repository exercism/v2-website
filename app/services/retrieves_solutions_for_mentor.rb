class RetrievesSolutionsForMentor
  def self.retrieve(*args)
    new(*args).retrieve
  end

  def initialize(mentor, status: nil, track_id: nil, exercise_id: nil)
    @solutions = mentor.mentored_solutions
    @status = status
    @track_id = track_id
    @exercise_id = exercise_id
  end

  def retrieve
    filter_by_status!
    filter_by_track! if track_id.present?
    filter_by_exercise! if exercise_id.present?

    solutions
  end

  private
  attr_reader :solutions, :status, :track_id, :exercise_id

  def filter_by_status!
    @solutions = FiltersSolutionsByStatus.filter(solutions, status)
  end

  def filter_by_track!
    @solutions = @solutions.
      joins(:exercise).
      where(exercises: { track_id: track_id })
  end

  def filter_by_exercise!
    @solutions = @solutions.
      joins(:exercise).
      where(exercises: { id: exercise_id })
  end
end
