module SPI
  class TestRunnerController < BaseController
    def languages
      langs = Infrastructure::TestRunner.all.each_with_object({}) do |tr, h|
        h[tr.language_slug] = {
          timeout_ms: tr.timeout_ms,
          container_slug: tr.version_slug,
          num_processors: tr.num_processors
        }
      end

      render json: { languages: langs }
    end

    def submissions_to_test
      ss = Submission.where(tested: false).
                      where("created_at > ?", Time.current - 1.minute).
                      limit(100).
                      includes(solution: {exericse: :track})

      render json: {
        submissions: ss.map {|submission|
          {
            uuid: submission.uuid,
            language_slug: submission.solution.exercise.language_track.slug,
            exercise_slug: submission.solution.exercise.slug,
          }
        }
      }
    end

    def submission_tested
      submission = Submission.find_by_uuid!(params[:submission_uuid])
      SubmissionServices::ProcessTestRun.(
        submission,
        params[:ops_status],
        params[:ops_message],
        params[:results].try {|r| r.permit!.to_h }
      )
      render json: {received: :ok}
    end
  end
end

