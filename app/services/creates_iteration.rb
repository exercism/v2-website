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
    Iteration.create!(
      solution: solution,
      code: code
    )
  end
end
