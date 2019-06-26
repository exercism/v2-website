module AnalysisServices
  class ProcessAnalysis
    include Mandate

    def initialize(iteration, analysis_status, analysis)
      @iteration = iteration
      @analysis_status = analysis_status.to_s.to_sym
      @analysis = analysis.is_a?(Hash) ? analysis.symbolize_keys : {}
    end

    def call
      create_database_record
      handle_analysis
      remove_system_lock
    end

    private
    attr_reader :iteration, :analysis_status, :analysis

    def create_database_record
      IterationAnalysis.create!(
        iteration: iteration,
        status: analysis_status,
        analysis: analysis
      )
    end

    def handle_analysis
      return unless solution.use_auto_analysis?
      return unless analysis_succeeded?

      case analysis[:status].to_s.to_sym
      when :approve,
           :approve_as_optimal, :approve_with_comment # Legacy statuses

        PostComments.(iteration, analysis[:comments]) if analysis[:comments].present?
        Approve.(solution)
      else
        # We currently don't do anything with non-approved solutions
      end
    end

    def remove_system_lock
      solution.solution_locks.where(user_id: User::SYSTEM_USER_ID).destroy_all
    end

    def analysis_succeeded?
      analysis_status == :success
    end

    memoize
    def solution
      iteration.solution
    end

    memoize

    def system_user
      User.system_user
    end
  end
end
