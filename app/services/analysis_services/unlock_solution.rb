module AnalysisServices
  class UnlockSolution
    include Mandate

    initialize_with(:solution)

    def call
      solution.solution_locks.where(user_id: User::SYSTEM_USER_ID).destroy_all
    end
  end
end
