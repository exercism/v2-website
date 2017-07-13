class CreatesIteration
  def self.create!(*args)
    new(*args).create!
  end

  attr_reader :solution, :code
  def initialize(solution, code)
    @solution = solution
    @code = code
  end

  def create!
    iteration = Iteration.create!(
      solution: solution,
      code: code
    )
    # TODO - iterate requires_action
    solution.update(last_updated_by_user_at: DateTime.now)
    iteration
  end
end
