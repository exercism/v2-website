class RetrievesSolutionsForMentor
  def self.retrieve(*args)
    new(*args).retrieve
  end

  def initialize(mentor, filter)
    @solutions = mentor.mentored_solutions
    @filter = filter
  end

  def retrieve
    filter_by_status! if filter

    solutions
  end

  private
  attr_reader :solutions, :filter

  def filter_by_status!
    @solutions = FiltersSolutionsByStatus.filter(solutions, filter)
  end
end
