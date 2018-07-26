class SwitchSolutionToMentoredMode
  include Mandate

  attr_reader :solution
  def initialize(solution)
    @solution = solution
  end

  def call
    solution.update(
      independent_mode: false,
      completed_at: nil,
      published_at: nil,
      approved_by: nil,
      last_updated_by_user_at: Time.now,
      updated_at: Time.now
    )
  end
end

